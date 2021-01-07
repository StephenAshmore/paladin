# Instruction Set

Instruction set currently contains 22 different instructions or opcodes. Working with memory is not yet supported, but is expected to be in the form of the load command.

Until a better method of implementing registers using an actual byte method, the logic opcodes will not be implemented. Also, most opcodes here will handle large integers, because of the simplistic nature in which they are implemented. When a method to implement registers in a more realistic way is determined, these opcodes will be re-written.

## Arithmetic Opcodes
* add  
	addition operands: [register] [register/number]
* sub  
	subtraction operands: [register] [register/number]
* div  
	division operands: [register] [register/number]
* mul  
	multiplication operands: [register] [register/number]

## Register Management Opcodes
* mov  
	move a value into a register. operands: [register] [register/number]
* load  
	load a register with a value from memory. operands: [register]
* print  
	print contents of a register to the console. operands: [register]
* printall
	prints the contents of all registers as a name, value list of tuples to the console. no operands

## Logic Opcodes
* and
* or
* not
* xor

## Loop Opcodes
* loop
* decr
* incr

## Branch Opcodes
* label
	name the instruction/"line" for later user. operands: [label-name]
* jump
	jump to a pre-defined label. operands: [label-name]
* tjmp
	if the test register (TCX) is true(1), jump to the specified label. operands: [label-name]
* fjmp
	if the test register (TCX) is false(0), jump to the specified label. operands: [label-name]

## String manipulation
* prts
	print an arbitrary string to the console. operands: ["string here"]

## Interacting with Modules
* modules
	prints the names of the modules to the console. no operands.
* tape
	tape is the high level operation for manipulating the tape module.
	- input
		`tape input` inserts the operand into the current pointer location of the tape and moves the pointer to the next entry. operands: [register/value]
	- output
		`tape output` returns the value at the current pointer location of the tape and places it into the requested register. operands: [register]
	- seek
		`tape seek` moves the tape to the requested location. operands: [register/value]
	- step
		`tape step` steps the tape one location forward. no operands.
