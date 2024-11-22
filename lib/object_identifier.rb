# frozen_string_literal: true

# ObjectIdentifier is the top-level namespace/module for this gem.
module ObjectIdentifier
end

require "object_identifier/version"
require "object_identifier/configuration"
require "object_identifier/object_identifier"
require "object_identifier/array_wrap"
require "object_identifier/parameters"

# FORMATTERS

require "object_identifier/formatters/base_formatter"
require "object_identifier/formatters/string_formatter"

# CORE EXTENSIONS

require "core_ext/object"
