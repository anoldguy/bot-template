class Hello < Cognition::Plugins::Base
  # Simple string based matcher. Must match *EXACTLY*
  match 'hello', :hello, help: { 'hello' => 'Returns Hello World' }

  # Advanced Regexp based matcher. Capture groups are made available
  # via MatchData in the matches method
  match /hello\s*(?<name>.*)/, :hello_person, help: {
    'hello <name>' => 'Greets you by name!'
  }

  match /hi/, :hello_metadata, help: {
    'hi' => 'Greets you by name!'
  }

  def hello_metadata(msg, match_data = nil)
    "Hello, #{msg.metadata["user"]["name"]}!"
  end

  def hello(*)
    'Hello World'
  end

  def hello_person(msg, match_data = nil)
    name = match_data[:name]
    "Hello #{name}"
  end
end
