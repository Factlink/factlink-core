load_fact_data do
  user "merijn"
  fact 'Batman is a fictional character created by the artist Bob Kane and writer Bill Finger',"http://en.wikipedia.org/wiki/Batman"
  fact 'Batman\'s secret identity is Bruce Wayne',"http://en.wikipedia.org/wiki/Batman"
  fact 'Batman operates in the fictional American Gotham City',"http://en.wikipedia.org/wiki/Batman"
  fact 'Batman operates in the fictional American Gotham City',"http://en.wikipedia.org/wiki/Batman"
  fact 'Batman operates in the fictional American Gotham City',"http://en.wikipedia.org/wiki/Batman"
  fact 'Batman operates in the fictional American Gotham City',"http://en.wikipedia.org/wiki/Batman"
  fact 'Batman operates in the fictional American Gotham City',"http://en.wikipedia.org/wiki/Batman"
  fact 'He fights an assortment of villains such as the Joker, the Penguin, Two-Face, Poison Ivy and Catwoman',"http://en.wikipedia.org/wiki/Batman"
  fact 'The late 1960s Batman television series used a camp aesthetic which continued to be associated with the character for years after the show ended',"http://en.wikipedia.org/wiki/Batman"

  fact 'example is example'
  fact 'ex'

  fact_relation 'je moeder',:supporting,'example is examples'
  fact_relation 'He fights an assortment of villains such as the Joker, the Penguin, Two-Face, Poison Ivy and Catwoman', :supporting, 'Batman is a fictional character created by the artist Bob Kane and writer Bill Finger'


  fact 'playboy',"http://en.wikipedia.org/wiki/Batman"
  fact 'industrialist',"http://en.wikipedia.org/wiki/Batman"
  fact "continuous war on crime","http://en.wikipedia.org/wiki/Batman"
  fact 'revenge on crime',"http://en.wikipedia.org/wiki/Batman"
  fact 'philanthropist',"http://en.wikipedia.org/wiki/Batman"

  user "mark"
  channel "foo"
    add_fact "playboy"
    add_fact "industrialist"
    del_fact "je moeder"
    sub_channel "merijn", "foobar"
    sub_channel "tomdev", "dinges"

  user "merijn"
  channel "foobar"

  user "mark"
    channel "foobar"
      sub_channel "merijn", "foobar"
end