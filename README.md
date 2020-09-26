##AsyncDemo

This project illustrates async functions and how you can call them.


All the code is in ViewController.swift.

in ViewDidLoad we call the function `doAsyncStuff()`, which kicks off the async example

The function `doAsyncStuff()` runs a loop from 1 to 5. On each pass through the loop it calls the function `asyncFunc(callCount:,completion:)`, which takes a call count and a comlpletion handler.

```
func doAsyncStuff() {
    //Run a loop on the main thread
    for callCount in 1...5 {

        //#1 inside loop, about to call asyncFunc
        print("About to call asyncFunc. callCount = \(callCount)")

        asyncFunc(callCount: callCount) { result in
            //#2 In completion handler after async function finishes
            print("In completion handler. Result = \(result). callCount = \(callCount)")
        }
    }
}
```
The function `asyncFunc(callCount:,completion:)` uses a call to `asyncAfter()` to simulate a network call or some other asynchronous event that takes a variable amount of time to run.

```
func asyncFunc(callCount: Int, completion: @escaping (Bool) -> ()) {
    //#3 Entering asyncFunc
    print("  Entering \(#function). callCount = \(callCount)")

    //#4 Pick a random delay value from 0.01 to 0.2
    let delay = Double.random(in: 0.01...0.2)
    print(String(format: "    About to call asyncAfter with delay %.2f", delay))

    //#5 asyncAfter() call
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
        completion(Bool.random())
    }

    //#6 Leaving asyncFunc
    print("  Leaving \(#function). callCount = \(callCount)")
}
```

At #5, The call to `asyncAfter(deadline:execute:)` returns immediately, but adds the closure that is passed to it to an async dispatch queue which runs on the main thread. The closure will be run after the time specified by the `deadline` parameter. The value `deadline` is of type `DispatchTime`, which is Unix representation of the system time. The expresion `.now()` represents the time at the instant it is evaluated, and `.now() + delay` specifies a time `delay` seconds in the future. 

Afer the specified delay, the dispatch queue will run the closure provide by the `execute` parameter. (The code above uses "trailing closure" syntax, where you skip the label on the final parameter if it is a closure and just provide a block of code enclosed in braces right after the function call. 



