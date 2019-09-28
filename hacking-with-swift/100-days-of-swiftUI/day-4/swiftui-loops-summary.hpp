//
//  swiftui-loops-summary.hpp
//  hacking-with-swift
//
//  Created by rafaelviewcontroller on 9/27/19.
//  Copyright © 2019 rafaelviewcontroller. All rights reserved.
//

#ifndef swiftui_loops_summary_hpp
#define swiftui_loops_summary_hpp

#include <stdio.h>

#endif /* swiftui_loops_summary_hpp */

//You’ve made it to the end of the fourth part of this series, so let’s summarize:
//
//Loops let us repeat code until a condition is false.
//The most common loop is for, which assigns each item inside the loop to a temporary constant.
//If you don’t need the temporary constant that for loops give you, use an underscore instead so Swift can skip that work.
//There are while loops, which you provide with an explicit condition to check.
//Although they are similar to while loops, repeat loops always run the body of their loop at least once.
//You can exit a single loop using break, but if you have nested loops you need to use break followed by whatever label you placed before your outer loop.
//You can skip items in a loop using continue.
//Infinite loops don’t end until you ask them to, and are made using while true. Make sure you have a condition somewhere to end your infinite loops!
