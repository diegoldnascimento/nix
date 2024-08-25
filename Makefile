
# Automatically get the hostname via shell
HOSTNAME := $(shell hostname)

############################################################################
#
#  Darwin related commands
#
############################################################################


# Build and switch for Darwin
darwin: darwin-set-proxy
	nix build .#darwinConfigurations.$(HOSTNAME).system \
		--extra-experimental-features 'nix-command flakes'
	./result/sw/bin/darwin-rebuild switch --flake .#$(HOSTNAME)

# Debug build and switch for Darwin
darwin-debug: darwin-set-proxy
	nix build .#darwinConfigurations.$(HOSTNAME).system --show-trace --verbose \
		--extra-experimental-features 'nix-command flakes'
	./result/sw/bin/darwin-rebuild switch --flake .#$(HOSTNAME) --show-trace --verbose

############################################################################
#
#  nix related commands
#
############################################################################

# Update nix flake
update:
	nix flake update

# Show nix profile history
history:
	nix profile history --profile /nix/var/nix/profiles/system

# Clean older generations and garbage collect
gc:
	# Remove all generations older than 7 days
	sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 7d
	# Garbage collect all unused nix store entries
	sudo nix store gc --debug

# Format nix files
fmt:
	# Format the nix files in this repo
	nix fmt

# Clean result directory
clean:
	rm -rf result
