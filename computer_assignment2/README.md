# Computer Assignment 2

Create the `run.do` file like this:

```
vlog -reportprogress 300 -work work "path_to/mano_core.v"
vlog -reportprogress 300 -work work "path_to/mano_core_tb.v"
vsim -gui work.mano_core_tb -voptargs=+acc
do wave.do
run 100ns
```

Run the simulation:

```
do run.do
```

## Tasks

- [x] Copy the lower 12bits from IR to AR
- [x] Copy IR[15] to i
- [x] Add missed increment operations in State machine always
- [x] Implement all 12 register instructions
- [x] Implement all 7 memory instructions
- [ ] Implement IO instructions
- [x] Read memory contents from a file
