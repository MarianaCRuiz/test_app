describe 'HTTParty' do
  it 'content-type', vcr: { cassette_name: 'HTTParty/content-type', match_requests_on: [:body] } do
    response = HTTParty.get('https://jsonplaceholder.typicode.com/posts/2')
    content_type = response.headers['content-type']
    expect(content_type).to match(/application\/json/)
  end
  it 'content-type 2', vcr: { cassette_name: 'HTTParty/content-type', record: :new_episodes } do
    response = HTTParty.get('https://jsonplaceholder.typicode.com/posts/3')
    content_type = response.headers['content-type']
    expect(content_type).to match(/application\/json/)
    #end
  end
end