# To learn more about Custom Resources, see https://docs.chef.io/custom_resources.html

resource_name :generate_style_css

property :id, String, name_attribute: true
property :file_path, String, required: true

default_css_hash = {
  body: {
    width: '750px',
  },
  h1: {
    color: 'blue',
    align: 'center',
  },
  p: {
    color: 'red',
    align: 'right',
  },
}

property :config_hash, Hash, default: default_css_hash
property :owner, String, default: 'root'
property :group, String, default: 'root'

default_action :create

action :create do
  template new_resource.file_path do
    source 'resource_templates/style.css.erb'
    cookbook 'linux_base'
    owner new_resource.owner
    group new_resource.group
    variables(
      configHash: new_resource.config_hash
    )
    action :create
  end
end
