# Define the dependencies
DEPENDENCIES = chafa convert jq curl

# Define the installation directories
INSTALL_DIR = /usr/local

# Installation instructions
install: check_dependencies
	@echo "Installing..."
	sudo mkdir -pv $(INSTALL_DIR)
	sudo cp -rv bin $(INSTALL_DIR)
	sudo cp -rv share $(INSTALL_DIR)
	@echo "Installation complete."

# Uninstallation instructions
uninstall:
	@echo "Uninstalling..."
	sudo rm -rf $(INSTALL_DIR)/bin
	sudo rm -rf $(INSTALL_DIR)/share
	@echo "Uninstallation complete."

# Target to check dependencies
check_dependencies:
	@echo "Checking dependencies..."
	@for dep in $(DEPENDENCIES); do \
		command -v $$dep >/dev/null 2>&1 || { echo "$$dep is required but not installed. Aborting."; exit 1; }; \
	done


.PHONY: install uninstall check_dependencies

