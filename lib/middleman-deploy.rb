require "middleman-core"

::Middleman::Extensions.register(:deploy) do
  require "middleman-deploy/extension"
  ::Middleman::Deploy
end
