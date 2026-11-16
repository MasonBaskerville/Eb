Set INT x = 4
Set INT y = 15
if(x == 5){
    OutputLine : "the number is 5"
    if(y == 3){
        OutputLine : "y is 15"
    }
    else{
        OutputLine : "y is not 15"
    }
}
else{
    OutputLine : "the number is not 5"
    if(y == 15){
        OutputLine : "this is a nested selection test"
    }
    else{
        OutputLine : "this is a test of nested else"
    }
}


#in READ.ME include how sin,cos and tan expect radians. so if working with
#degrees, the conversion must be inputed into the variable input: Set FLO z = sin(30 * pi/180)
#there is also the use of inverse trigonmetric functions and hyperbolic functions
#included: exponential function,natural logarithm,log and log10, and log2, absolute values, nearest
#integer, round down to the nearest integer, round up to the nearest integer , factorial, combinations,
#permutations, largest value, smallest value, pi, e, 2pi(tau).
