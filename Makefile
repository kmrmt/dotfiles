CONF_DIR := $(HOME)/.config
TARGET := git mise sheldon zsh starship.toml ghostty
CONF := $(addprefix config/,$(TARGET))

define symlink
	ln -s $(abspath $(1)) $(2)
endef

.PHONY: install/mise
install/mise: init
	curl https://mise.run | sh

.PHONY: init
init: install/zshenv install/config

.PHONY: install/config
install/config: $(CONF)

.PHONY: $(CONF)
$(CONF):
	$(call symlink,$@,$(HOME)/.config/$(subst config/,,$@))

.PHONY: install/zshenv
install/zshenv:
	$(call symlink,config/zshenv,$(HOME)/.zshenv)

$(CONF_DIR):
	mkdir -p $(CONF_DIR)
