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