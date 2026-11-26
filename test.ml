for (Set INT i = 0 : i < 100 : i = i + 1){
    if (i%5==0){
        if(i%3==0){
            OutputLine : "fizzbuzz"
        }
        else{
            OutputLine : "fizz"
        }
    }
    else if (i%3==0){
        OutputLine:"buzz"
    }
    else{
        OutputLine : "none"
    }
}

#in READ.ME include how sin,cos and tan expect radians. so if working with
#degrees, the conversion must be inputed into the variable input: Set FLO z = sin(30 * pi/180)
#there is also the use of inverse trigonmetric functions and hyperbolic functions
#included: exponential function,natural logarithm,log and log10, and log2, absolute values, nearest
#integer, round down to the nearest integer, round up to the nearest integer , factorial, combinations,
#permutations, largest value, smallest value, pi, e, 2pi(tau).
