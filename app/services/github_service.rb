class GithubService

  attr_reader :access_token

  def initialize(access_hash = nil)
    @access_token = access_hash["access_token"] if access_hash
  end

  def authenticate!(client_id, client_secret, code)
    response = Faraday.post "https://github.com/login/oauth/access_token",
    req.params['client_id'] = client_id
    req.params['client_secret'] = client_secret
    req.params['redirect_uri'] = "http://localhost:3000/auth"
    req.params['code'] = code
  end
  body = JSON.parse(resp.body)
  body["access_token"]
  end

  def get_username
    user_response = Faraday.get "https://api.github.com/user", {}, {'Authorization' => "token #{self.access_token}", 'Accept' => 'application/json'}
    user_json = JSON.parse(user_response.body)
    user_json["login"]
  end

  def get_repos
    response = Faraday.get "https://api.github.com/user/repos", {}, {'Authorization' => "token #{self.access_token}", 'Accept' => 'application/json'}
    repos_array = JSON.parse(response.body)
    repos_array.map{|repo| GithubRepo.new(repo) }
  end

  def create_repo(name)
    Faraday.post "https://api.github.com/user/repos", {name: name}.to_json, {'Authorization' => "token #{self.access_token}", 'Accept' => 'application/json'}
  end

end
