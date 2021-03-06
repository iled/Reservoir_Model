#
# Makefile for the grid-based semi-Lagrangian water temperature model, RBM10_VIC
#
# Start of the makefile
#
# Defining variables
#
objects = reservoir.o\
          Block_Energy.o Block_Reservoir.o Block_Flow.o\
	  Energy.o reservoir_subroutine.o flow_subroutine.o density_subroutine.o
	 	  
f90comp = gfortran
# Makefile
reservoir: $(objects)
	$(f90comp) -o reservoir $(objects)
Block_Energy.o: Block_Energy.f90
	$(f90comp) -c Block_Energy.f90
block_energy.mod: Block_Energy.o Block_Energy.f90
	$(f90comp) -c Block_Energy.f90
Block_Reservoir.o: Block_Reservoir.f90
	$(f90comp) -c Block_Reservoir.f90
block_reservoir.mod: Block_Reservoir.o Block_Reservoir.f90
	$(f90comp) -c Block_Reservoir.f90
Block_Flow.o: Block_Flow.f90
	$(f90comp) -c Block_Flow.f90
block_flow.mod: Block_Flow.o Block_Flow.f90
	$(f90comp) -c Block_Flow.f90
density_subroutine.o: density_subroutine.f90
	$(f90comp) -c density_subroutine.f90
Energy.o: block_energy.mod Energy.f90
	$(f90comp) -c Energy.f90
flow_subroutine.o: block_reservoir.mod block_energy.mod flow_subroutine.f90
	$(f90comp) -c flow_subroutine.f90
reservoir_subroutine.o: block_reservoir.mod block_flow.mod reservoir_subroutine.f90
	$(f90comp) -c reservoir_subroutine.f90
reservoir.o: block_energy.mod block_reservoir.mod block_flow.mod reservoir.f90
	$(f90comp) -c reservoir.f90

# Cleaning everything
clean:
	rm block_energy.mod block_reservoir.mod\
           reservoir
	rm $(objects)
