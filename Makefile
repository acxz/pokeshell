# Define the dependencies
DEPENDENCIES = chafa convert jq curl

# Define the installation directories
INSTALL_DIR = /usr/local

# Installation instructions
install: check_dependencies
	@echo "Installing..."
	@echo "Installed "
	sudo mkdir -pv $(INSTALL_DIR)
	sudo cp -rv bin $(INSTALL_DIR)
	sudo cp -rv share $(INSTALL_DIR)
	@echo "Installation complete."
	@echo "updating your $PATH variable"
	export PATH=$PATH:/usr/local/bin
	@echo "DONE pokeshell is now installed"

# Uninstallation instructions
uninstall:
	@echo "Uninstalling..."

	@echo "Removing files"	 
	sudo rm -rf $(INSTALL_DIR)/bin/pokeshell
	@echo "Removing Complitions"
	sudo rm -rf $(INSTALL_DIR)/share/bash-completion/completions/pokeshell

	@echo "Removing directories"
	sudo rmdir -v $(INSTALL_DIR)/bin
	sudo rmdir -v $(INSTALL_DIR)/share/bash-completion/completions
	sudo rmdir -v $(INSTALL_DIR)/share/bash-completion

	@echo "Uninstallation complete."

# Target to check dependencies
check_dependencies:
	@echo "Checking dependencies..."
	@for dep in $(DEPENDENCIES); do \
		command -v $$dep >/dev/null 2>&1 || { echo "$$dep is required but not installed. Aborting."; exit 1; }; \
	done


.PHONY: install uninstall check_dependencies

