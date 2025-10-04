CONF_DIR := $(HOME)/.config
TARGET := git mise sheldon zsh starship.toml ghostty
CONF := $(addprefix $(CONF_DIR)/,$(TARGET))
GHQ_ROOT := $(HOME)/.ghq/src

define symlink
	ln -s $(abspath $(1)) $(2)
endef

.PHONY: install/mise
install/mise: init
	curl https://mise.run | sh

.PHONY: link/config
link/config: $(CONF) link/zshenv

$(CONF_DIR)/%: config/%
	$(call symlink,$<,$@)

.PHONY: link/zshenv
link/zshenv: $(HOME)/.zshenv

$(HOME)/.zshenv: config/zshenv
	$(call symlink,$<,$@)

$(CONF_DIR):
	mkdir -p $(CONF_DIR)

.PHONY: unlink/config
unlink/config:
	rm $(HOME)/.zshenv $(CONF)
