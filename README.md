##AsyncDemo

This project illustrates async functions and how you can call them.


All the code is in ViewController.swift.

in ViewDidLoad we call the function `doAsyncStuff()`, which kicks off the async example

The function `doAsyncStuff()` runs a loop from 1 to 5. On each pass through the loop it calls the function `asyncFunc(callCount:,completion:)`, which takes a call count and a comlpletion handler.

At #1 below, we print a message to the console on each pass through the loop

At #2, inside the completion handler for the call to `asyncFunc()`, we print another message to the console.

```
func doAsyncStuff() {
    //Run a loop on the main thread
    for callCount in 1...5 {

        //#1 inside loop, about to call asyncFunc
        print("About to call asyncFunc. callCount = \(callCount)")

        asyncFunc(callCount: callCount) { result in
            //MARK: - This is the completion handler
            //#2 In completion handler after async function finishes
            print("In completion handler. Result = \(result). callCount = \(callCount)")
            //MARK: -
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
        //MARK: - This is the closure code that is run after a delay
        completion(Bool.random())
        //MARK: - End of closure code
    }

    //#6 Leaving asyncFunc
    print("  Leaving \(#function). callCount = \(callCount)")
}
```

At #3, the function prints a message to the console recording when it enters the function.

At #4 we generate a delay value between 0.01 and 0.2 seconds.

At #5, The call to `asyncAfter(deadline:execute:)` returns immediately, but adds the closure that is passed to it to an async dispatch queue which runs on the main thread. The closure will be run after the time specified by the `deadline` parameter. The value `deadline` is of type `DispatchTime`, which is Unix representation of the system time. The expresion `.now()` represents the time at the instant it is evaluated, and `.now() + delay` specifies a time `delay` seconds in the future. 

Afer the specified delay, the dispatch queue will run the closure provide by the `execute` parameter. (The code above uses "trailing closure" syntax, where you skip the label on the final parameter if it is a closure and just provide a block of code enclosed in braces right after the function call.)


-------------
## Thought Exercise:

See if you can predict what the console output will look like. Think it through, write down your prediction, and then see below for sample output:
<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>




## Sample output:

```
About to call asyncFunc. callCount = 1
  Entering asyncFunc(callCount:completion:). callCount = 1
    About to call asyncAfter with delay 0.16
  Leaving asyncFunc(callCount:completion:). callCount = 1
About to call asyncFunc. callCount = 2
  Entering asyncFunc(callCount:completion:). callCount = 2
    About to call asyncAfter with delay 0.05
  Leaving asyncFunc(callCount:completion:). callCount = 2
About to call asyncFunc. callCount = 3
  Entering asyncFunc(callCount:completion:). callCount = 3
    About to call asyncAfter with delay 0.14
  Leaving asyncFunc(callCount:completion:). callCount = 3
About to call asyncFunc. callCount = 4
  Entering asyncFunc(callCount:completion:). callCount = 4
    About to call asyncAfter with delay 0.07
  Leaving asyncFunc(callCount:completion:). callCount = 4
About to call asyncFunc. callCount = 5
  Entering asyncFunc(callCount:completion:). callCount = 5
    About to call asyncAfter with delay 0.09
  Leaving asyncFunc(callCount:completion:). callCount = 5
In completion handler. Result = true. callCount = 2
In completion handler. Result = true. callCount = 4
In completion handler. Result = true. callCount = 5
In completion handler. Result = true. callCount = 3
In completion handler. Result = true. callCount = 1
```

## Explanation:

All the code in `doAsyncStuff()` except the code between the `MARK:` statements is run synchronously (from beginning to end) on the main thread. Likewise, all the code in `asyncFunc()` except the code between its `MARK:` statements is run synchronously on the main thread. The call to `DispatchQueue.main.asyncAfter()` returns immedately, and passes a block of code to the system to run after a delay.

Therefore, **all** of the print statements in the program except the one that prints `In completion handler` get run in order. The print statement at #2 in the completion handler does not get run until the loop in `doAsyncStuff()` has finished.

Since each of the calls to `DispatchQueue.main.asyncAfter() has a random delay value, you can't tell in advance what order those closures (and their print statements) will be run. Each time the program is run the calls will complete in a different, random order. (You can figure out the order in which the closures will be run by looking at the output of The print statement "About to call asyncAfter with delay x". The one with the shortest delay will be printed first.)

This does a decent job of simulating what happens when you do async network calls. Network calls like `dataTask(with:completionHandler:)` run their network transactions asynchronously on a background thread. The call returns immediately, and once the network call is complete, the system calls your completionHandler. If you submit multiple network requests in a row, without waiting for each to complete before submitting the next, you can't predict the order in which they will complete. They will very likely NOT complete in the same order in which you submit them.