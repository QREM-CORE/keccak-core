# =====================
# ModelSim Multi-TB Makefile
# =====================

# List of testbenches (leave empty if none)
TESTBENCHES =
# RTL design files
DESIGN_SRCS = rtl/keccak_core.sv
# Common include files
COMMON_SRCS = rtl/keccak_constants.svh
# Work library
WORK = work

# Default target
all: $(WORK)
ifeq ($(strip $(TESTBENCHES)),)
	@echo "No testbenches specified. Compiling RTL only..."
	vlog -work $(WORK) -sv $(DESIGN_SRCS) $(COMMON_SRCS)
else
	$(MAKE) run_all
endif

# Create ModelSim work library
$(WORK):
	vlib $(WORK)

# Run all testbenches
run_all: $(TESTBENCHES:%=run_%)

# Rule for each testbench
run_%: $(WORK)
	@echo "=== Running $* ==="
	vlog -work $(WORK) -sv $(DESIGN_SRCS) $(COMMON_SRCS) $*.sv
	@echo 'vcd file "$*.vcd"' > run_$*.macro
	@echo 'vcd add -r /$*/*' >> run_$*.macro
	@echo 'run -all' >> run_$*.macro
	@echo 'quit' >> run_$*.macro
	vsim -c -do run_$*.macro $(WORK).$*
	rm -f run_$*.macro

# Clean build files
clean:
	rm -rf $(WORK) *.vcd transcript vsim.wlf run_*.macro
