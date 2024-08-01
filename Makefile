.PHONY: clean

# be careful here, only delete processed data that you generated with the pipeline
clean:
	rm -rf data/processed/
	rm -rf plots
	rm -rf reports/

.PHONY: dirs
DIRS = data/processed/ plots/ reports/
dirs:
	mkdir -p $(DIRS)