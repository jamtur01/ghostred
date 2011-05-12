require 'octokit'
require 'redmine_client'

module GhostRed
 class Base

  PROJECT_MAP = { 
    "marionette-collective" => "mcollective",
    "puppet-acceptance"     => "testing-matrix",
    "puppet-vcsrepo"        => "modules",
    "puppet-dashboard"      => "dashboard"
  }

  def self.run(rm_token,rm_site,gh_org,gh_user,gh_token)
    @gh_org = gh_org
    @gh_user = gh_user
    @gh_token = gh_token
    configure_rm(rm_token,rm_site)
    repo_list = get_org_repos
    @project_list = get_redmine_projects
    get_pull_requests(repo_list)
  end

  def self.configure_rm(rm_token,rm_site)
    RedmineClient::Base.configure do
      self.site = rm_site
      self.user = rm_token
    end
    puts "Connected to Redmine..."
  end

  def self.get_org_repos
    repo_list = []
    repos = Octokit.repositories(@gh_org)
    repos.each do |r|
      repo_list << r.name
    end
    puts "Getting list of repositories from GitHub"
    return repo_list
  end

  def self.get_redmine_projects
    project_list = {}
    projects = RedmineClient::Project.find(:all)
    projects.each do |p|
      project_list[p.id] = p.identifier
    end
    puts "Getting list of projects from Redmine"
    return project_list
  end

  def self.get_pull_requests(repo_list)
    puts "Getting list of GitHub pull requests"
    repo_list.each do |repo|
      pull = Octokit.pull_requests("#{@gh_org}/#{repo}")
        unless pull.empty?
          number = pull[0]["number"]
          body = pull[0]["body"]
          title = pull[0]["title"]
          rep = pull[0]["head"]["repository"]["name"]
          branch = pull[0]["html_url"]
          body = title if body.empty?
          open_redmine_ticket(number,body,title,rep,branch)
        end
    end
  end

  def self.open_redmine_ticket(number,body,title,repo,branch)
    if @project_list.has_value?(repo)
      identifier = repo
    elsif
      identifier = PROJECT_MAP[repo]
    else
      puts "#{repo} needs a PROJECT_MAP entry"
      return
    end
    id = @project_list.key(identifier)
    issue = RedmineClient::Issue.new(
         :subject => title,
         :project_id => id,
         :description => body,
         :status_id => '11',
         :assigned_to_id => '380',
         :custom_field_values => { '13' => branch }
    )
    if issue.save
      url = "https://projects.puppetlabs.com/issues/#{issue.id}"
      close_pull_request(number,repo,url)
    else
      puts issue.errors.full_messages
    end
  end

  def self.close_pull_request(number,repo,url)
    @gh_client = Octokit::Client.new(:login => @gh_user, :token => @gh_token)
    puts "Adding comment to GitHub pull request at #{repo}:#{number}"
    comment = "Thanks for your request! It's been moved to our Redmine ticket tracker and you can now track this issue at #{url}"
    @gh_client.add_comment({:username => @gh_org, :repo => repo}, number, comment)
    puts "Closing GitHub issue #{repo}:#{number}"
    @gh_client.close_issue("#{@gh_org}/#{repo}", number)
  end

 end
end
