name 'keystorm'
default_version 'v1.1.0'

license "Apache-2.0"
license_file "LICENSE"

dependency 'ruby'
dependency 'rubygems'
dependency 'liblzma'

env = {
  'LDFLAGS' => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  'CFLAGS' => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  'LD_RUN_PATH' => "#{install_dir}/embedded/lib",
}

source git: 'https://github.com/the-rocci-project/keystorm.git'

build do
  gem "install bundler -n #{install_dir}/embedded/bin --no-rdoc --no-ri"
  bundle "install --deployment --without development test --path=#{install_dir}/embedded/app/vendor/bundle", :env => env
  sync project_dir, "#{install_dir}/embedded/app/keystorm", exclude: %w[.git .gitignore]

  mkdir "#{install_dir}/examples/"
  copy File.join(project.files_path, '*'), "#{install_dir}/examples/"
  copy File.join(project.files_path, 'bin', '*'), "#{install_dir}/bin/"

  delete "#{install_dir}/embedded/app/keystorm/vendor/bundle"
  delete "#{install_dir}/embedded/app/vendor/bundle/ruby/*/cache/*"
end
