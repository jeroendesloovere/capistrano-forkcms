# Set some Capistrano defaults
set :linked_files, []
set :linked_files,  %w(app/config/parameters.yml)
set :linked_dirs, []
set :linked_dirs, %w(app/logs app/sessions src/Frontend/Files)

# Run required tasks after the stage
Capistrano::DSL.stages.each do |stage|
  after stage, 'forkcms:configure:composer'
  after stage, 'forkcms:configure:cachetool'
end


# Make sure the composer executable is installed
namespace :deploy do
  after :starting, 'composer:install_executable'
  after :starting, 'cachetool:install_executable'
  after :publishing, 'forkcms:symlink:document_root'
  after :publishing, 'forkcms:opcache:reset'
end


# Load the tasks
load File.expand_path('../../tasks/configure.rake', __FILE__)
load File.expand_path('../../tasks/opcache.rake', __FILE__)
load File.expand_path('../../tasks/symlink.rake', __FILE__)
