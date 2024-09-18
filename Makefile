CONF_DIR := $HOME/.config
CONF_FILES := alacritty git mise sheldon tmux zsh starship.toml

def symlimk
	ln -s $(1) $(2)
endef

def symlimk1
	$(call symlimk, ./$(1), $(CONF_DIR)/$(1))
endef

.PHONY: install/mise
install/mise:
	curl https://mise.run | sh

init: $(CONF_DIR) zshenv
	$(foreach cfg,$(CONF_FILES),$(call symlimk1, $(cfg)))

.PHONY: zshenv
zshenv:
	$(call symlimk, zshenv, $(HOME)/.zshenv)

$(CONF_DIR):
	mkdir -p $(CONF_DIR)
