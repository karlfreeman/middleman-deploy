require 'middleman-core'

require 'middleman-deploy/commands'

::Middleman::Extensions.register(:deploy) do
  require 'middleman-deploy/extension'
  ::Middleman::Deploy
end
