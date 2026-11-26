# Eb
my own scripting language in fish

the aim of Eb is to make a language which is a bridge between something like python and C/C#. as i found when i started the jump was understandable but small things made no sense. so by mixing the 2 it allows for an easier gateway into C/C#. i swapped out syntax from other languges which would have been a bti confusing for some. e.g. **Console.WriteLine()** got replaces with **OutputLine :** this makes it little more obvious what the syntax does. this is the exact same things with variable creation. variables need to be **Set** in order to be created, which is diffrent from how python runs but more similar to C and C#. **this was not designed to be used a full language like C or C# or even python but a scripting language to bridge the 2**

there are still some bugs thorughout which need work. such as some small math error when using for loops which contain else if statements and nested selection. some math operators cannot be used in for loops *e.g.* +=.
the next major things to add are syntax like **AND** and **OR** and the addition of adding subprograms to this.
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

# Set up (windows 10 & 11)
run the follwoing commands to set up the environment of FISH
```powershell
wsl -- install -d ubuntu
```
restart if prompted then open ubuntu and run:
```bash
sudo apt update
sudo apt install fish
```
start fish : 
```bash
fish
```
run the interpreter
```text
fish Eb.fish test.ml
```

#linux set up
```bash
sudo apt install fish
```
start fish : 
```bash
fish
```
run the interpreter :
```text
fih Eb.fish test.ml
```

if you use arch linux you should already have fish as the native scripting language and can just run the following command :
```text
fish Eb.fish test.ml
```



