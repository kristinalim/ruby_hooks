Gem::Specification.new do |s|
  s.name = %q{ruby-hooks}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Kristina Lim"]
  s.date = %q{2009-02-20}
  s.description = %q{This library adds support for chained before, after, and around method callbacks to Ruby.}
  s.email = ["kristina@syndeomedia.com"]
  s.extra_rdoc_files = ["README"]
  # s.files = ["History.txt", "License.txt", "Manifest.txt", "PostInstall.txt", "README.txt", "Rakefile", "config/hoe.rb", "config/requirements.rb", "examples/aaws.rb", "examples/delicious.rb", "examples/twitter.rb", "examples/whoismyrep.rb", "httparty.gemspec", "lib/httparty.rb", "lib/httparty/core_ext.rb", "lib/httparty/core_ext/hash.rb", "lib/httparty/version.rb", "script/console", "script/destroy", "script/generate", "script/txt2html", "setup.rb", "spec/hash_spec.rb", "spec/httparty_spec.rb", "spec/spec.opts", "spec/spec_helper.rb", "tasks/deployment.rake", "tasks/environment.rake", "tasks/website.rake", "website/css/common.css", "website/index.html"]
  s.has_rdoc = true
  s.homepage = %q{http://i-think.com.ph/kristina}
  s.post_install_message = %q{}
  s.rdoc_options = ["--main", "README"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{ruby-hooks}
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{Support for chained method callbacks.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2
  else
  end
end
