# frozen_string_literal: true
namespace :runit do
  task :set_vars do
    set :runit_sv_dir, fetch(:runit_sv_dir, '~/sv')
    set :runit_service_dir, fetch(:runit_service_dir, '~/service')
    set :runit_sv_executable, fetch(:runit_sv_executable, 'sv')
  end
end

def runit_controls(name, roles) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
  namespace :runit do
    namespace name do
      desc "Up #{name}"
      task up: 'runit:set_vars' do
        on roles(*roles), in: :groups, limit: 4 do
          runit_sv_executable = fetch(:runit_sv_executable)
          runit_service_dir = fetch(:runit_service_dir)
          execute runit_sv_executable, 'up', File.join(runit_service_dir, name)
        end
      end

      desc "Down #{name}"
      task down: 'runit:set_vars' do
        on roles(*roles), in: :groups, limit: 4 do
          runit_sv_executable = fetch(:runit_sv_executable)
          runit_service_dir = fetch(:runit_service_dir)
          execute runit_sv_executable, 'down', File.join(runit_service_dir, name)
        end
      end

      desc "Try to down #{name} (do not raise on command failure)"
      task try_down: 'runit:set_vars' do
        on roles(*roles), in: :groups, limit: 4 do
          runit_sv_executable = fetch(:runit_sv_executable)
          runit_service_dir = fetch(:runit_service_dir)
          execute runit_sv_executable, 'down', File.join(runit_service_dir, name), raise_on_non_zero_exit: false
        end
      end
      task 'try-down' => :try_down

      desc "Start #{name}"
      task start: 'runit:set_vars' do
        on roles(*roles), in: :groups, limit: 4 do
          runit_sv_executable = fetch(:runit_sv_executable)
          runit_service_dir = fetch(:runit_service_dir)
          execute runit_sv_executable, 'start', File.join(runit_service_dir, name)
        end
      end

      desc "Stop #{name}"
      task stop: 'runit:set_vars' do
        on roles(*roles), in: :groups, limit: 4 do
          runit_sv_executable = fetch(:runit_sv_executable)
          runit_service_dir = fetch(:runit_service_dir)
          execute runit_sv_executable, 'stop', File.join(runit_service_dir, name)
        end
      end

      desc "Try to stop #{name} (do not raise on command failure)"
      task try_stop: 'runit:set_vars' do
        on roles(*roles), in: :groups, limit: 4 do
          runit_sv_executable = fetch(:runit_sv_executable)
          runit_service_dir = fetch(:runit_service_dir)
          execute runit_sv_executable, 'stop', File.join(runit_service_dir, name), raise_on_non_zero_exit: false
        end
      end
      task 'try-stop' => :try_stop

      desc "Force stop #{name}"
      task force_stop: 'runit:set_vars' do
        on roles(*roles), in: :groups, limit: 4 do
          runit_sv_executable = fetch(:runit_sv_executable)
          runit_service_dir = fetch(:runit_service_dir)
          execute runit_sv_executable, 'force-stop', File.join(runit_service_dir, name), raise_on_non_zero_exit: false
        end
      end
      task 'force-stop' => :force_stop

      desc "Restart #{name}"
      task restart: 'runit:set_vars' do
        on roles(*roles), in: :groups, limit: 4 do
          runit_sv_executable = fetch(:runit_sv_executable)
          runit_service_dir = fetch(:runit_service_dir)
          execute runit_sv_executable, 'restart', File.join(runit_service_dir, name)
        end
      end

      desc "Force restart #{name}"
      task force_restart: 'runit:set_vars' do
        on roles(*roles), in: :groups, limit: 4 do
          runit_sv_executable = fetch(:runit_sv_executable)
          runit_service_dir = fetch(:runit_service_dir)
          execute runit_sv_executable, 'force-restart', File.join(runit_service_dir, name), raise_on_non_zero_exit: false
        end
      end
      task 'force-restart' => :force_restart

      desc "Disable #{name}"
      task disable: 'runit:set_vars' do
        on roles(*roles), in: :groups, limit: 4 do
          runit_service_dir = fetch(:runit_service_dir)
          execute 'rm', '-f', File.join(runit_service_dir, name)
        end
      end

      desc "Enable #{name}"
      task enable: 'runit:set_vars' do
        on roles(*roles), in: :groups, limit: 4 do
          runit_sv_dir = fetch(:runit_sv_dir)
          runit_service_dir = fetch(:runit_service_dir)
          execute 'mkdir', '-p', runit_service_dir
          execute 'ln', '-s', File.join(runit_sv_dir, name), File.join(runit_service_dir, name)
        end
      end
    end
  end
end
