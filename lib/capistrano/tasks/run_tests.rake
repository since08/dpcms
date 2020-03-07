namespace :deploy do
  desc "Runs test before deploying, can't deploy unless they pass"
  task :run_rspec do
    set :rails_env, 'test'
    invoke :'deploy:migrating'
    current_time = Time.now.strftime('%Y%m%d_%T')
    rspec_file = "#{current_time}_rspec.html"

    on fetch(:migration_servers) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, "exec rspec -f html -o ./public/files/#{rspec_file}"
        end
      end
    end
    project_url = fetch(:project_url)
    file_url = "#{project_url}/files/#{rspec_file}"
    puts "report rspec: #{file_url}"
  end
end