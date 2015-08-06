set :application, 'youversion-web'
set :repo_url, 'git@github.com:lifechurch/youversion-web.git'
set :deploy_to, '/var/www/youversion-web'
set :scm, :git
#set :format, :pretty
#set :log_level, :debug
set :pty, true
set :keep_releases, 5
set :rvm_type, :user
set :rvm_ruby_version, 'ruby-1.9.3-p551@youversion-web'

set :branch, ENV.fetch('BRANCH', 'master')

set :passenger_roles, :web
set :passenger_restart_with_sudo, true

set :default_env, {
  'SECURE_TRAFFIC' => true
}

require 'socket'

namespace :deploy do
  before :starting, :highstate do
    on roles(:web) do
      execute "sudo salt-call state.highstate"
    end
  end

  Rake::Task["deploy:symlink:release"].clear_actions
    namespace :symlink do
      desc 'OVERRIIIIIIDE'
      task :release do
        on roles(:web) do
          execute "ln -s #{release_path} #{deploy_to}/releases/current"
          execute "mv #{deploy_to}/releases/current #{deploy_to}"
          execute "sudo ln -nfs #{release_path}/nginx.conf-#{fetch(:stage)} /etc/nginx/nginx.conf"
          execute "sudo service nginx reload"
        end
      end
    end

  before :published, :curl do
    on roles(:web) do
      execute "curl http://local.bible.com -k || true"
    end
  end

end

namespace :memcached do
  desc "Flush memcached"
  task :flush, :roles => [:web] do
    execute "cd #{current_release} && RAILS_ENV=#{rails_env} rake memcached:flush"
  end
end
