# Eb
my own scripting language in fish

at the moment there are only 3 things which can be done. they are all a work in progress so they are the basic version of the syntax.

## current syntax

### variable handling
- Set : creates a variable
- INT : used to decalre an integer type
- FlO : used to declare a floating type
- STR : used to decalre a string type
- CHA : used to declare a character type
- BOO : used to decalre a boolean type

- READ : user input

### math operators
- '+' : sums varibales or integers / floats
- '-' : subtracts varibales or integers/floats
- '+=' : adds to a variable and reassigns 
- '-=' : subtracts from a variable and reassigns
- '<' : less than operator
- '>' : greater than operator
- '<=' : less than or equal to operator
- '>=' : greater than or equal to operator
- '!=' : does not equal operator
- '==' : equal to operator

### Output
- OutputLine : "this outputs on a seprate line each time"

- Output : "this outputs on the same line"

- Output : "this is outputting a varibale {varibale}"  + this works the same for OutputLine

### selection
- if(){} : if somethign is true, which is held in the () , then what ever is in the {} gets completed
-else if(){} : as a secondary if , an if must be used first then if the if returns fasle then if a else if is present the conditional check gets ran and if true then whatever is in the {} will be completed.
-else{} : if the if and/or else if statment returns false then whatever is in the {} will get completed.

### iteration
-break : used to forcefully exit a loop
-while(){} : whilst whatever in the () is true, whatever is in the {} will run forever unless the condintion is changed or stopped by the break command.
-for(init : condition : incrementation){} : the 'init' is where we create a variable to measure for the count controlled loop. the 'condition' checks something against this initialized variable. the 'incrementation' is used to increment thsi initialised variable to creat the count controlled loop. then whilst the condtion is met, whateevr is in the {} will run.

### math functions
- all the regular fish math functions work automatically, this covers a wide range from trigonometry to calculus
- as a pre-warning . if you are to use sin,cos tan,sec etc. it must be used in radians, or use the formuale (pi*n)/180. this will convert degrees to radians.

# examples
## variable an output syntax

```text
Set INT x = 10
Set INT y = 8

if (x==10){
    OutputLine: "x is 10"
}
else if (x>y){
    OutputLine : "x is greater than y"
}
else{
    OutputLine : "x is not 10"
}
```

## user input
```text
Set INT age = 0
Set STR name = ""
OutputLine: "enter your age "
age = READ
OutputLine : "enter your name"
name = READ
OutputLine : "your name is {name} and you are {age}"
```

## iteration
```text
for(Set INT i = 0 : i < 5 : i = i + 1){
    OutputLine : "the loop has been done {i} times"
}
```
```text
Set STR script = ""
while(script != fish){
    OutputLine : "enter a scripting language"
    script = READ
    if (script == "bash"){
        OutputLine "YOU FOUND THE BONUS ANSWER!!"
        break
    }
    else{
        OutputLine : "try again"
    }
}
```



