Set INT num = 4829
Set INT digits = 0

while(true){
    if (num==0){
        break
    }
    num = num // 10
    digits = digits + 1
}
OutputLine : "total digits: {digits}

#in READ.ME include how sin,cos and tan expect radians. so if working with
#degrees, the conversion must be inputed into the variable input: Set FLO z = sin(30 * pi/180)
#there is also the use of inverse trigonmetric functions and hyperbolic functions
#included: exponential function,natural logarithm,log and log10, and log2, absolute values, nearest
#integer, round down to the nearest integer, round up to the nearest integer , factorial, combinations,
#permutations, largest value, smallest value, pi, e, 2pi(tau).
