require 'octokit'
require 'redmine_client'
require 'json'
require 'pp'

module Ghostred

  def self.run(rm_token,rm_site,gh_org,gh_token)
    configure_gh(gh_org,gh_token)
    configure_rm(rm_token,rm_site)
    repo_list = get_org_repos(gh_org)
    get_pull_requests(repo_list)
  end

  def self.configure_gh(gh_org,gh_token)
    Octokit.configure do |config|
      config.login = gh_org
      config.token = gh_token
      config.endpoint = 'https://github.com'
    end
    puts "Configured GitHub..."
  end

  def self.configure_rm(rm_token,rm_site)
    RedmineClient::Base.configure do
      self.site = rm_site
      self.user = rm_token
    end
    puts "Configured Redmine..."
  end

  def self.get_org_repos(org)
    repo_list = []
    repos = Octokit.organization_repositories(org)
    repos.each do |r|
      repo_list << r["name"]
    end
    return repo_list
  end

  def self.get_pull_requests(repo_list)
    repo_list.each do |repo|
      pull = Octokit.pulls(repo)
      pp pull unless pull.empty?
    end
  end

  def self.close_pull_requests

  end

  def self.open_redmine_ticket

  end


end
