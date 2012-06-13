# coding: utf-8


class FakeFactsController < ApplicationController
  layout "fake_facts"
  include Gravatar
  include Redis::Aid::Ns(:fake_facts_controller)


  def facts
    [
      "After the printing press was invented, a dream dictionary called Oneirocritica (The Interpretation of Dreams) by second-century author Artemidorus Daldianus became one of the first best-sellers, comparable only to the Bible in popularity.",
      "Your nose can remember 50,000 different scents.",
      "People who go to church are less happy than those who don’t.",
      "Our “strong tie” group size has a limit of 150 people. The limit specifically refers to the number of people that you can maintain stable social relationships with. These are relationships where you know who the person is, and you know how each person relates to every other person in the group.",
      "The brain operates on the same amount of power as 10-watt light bulb. The cartoon image of a light bulb over your head when a great thought occurs isn’t too far off the mark. Your brain generates as much energy as a small light bulb even when you’re sleeping.",
      "You make most of your decisions consciously (like buying a television)",
      "Altitude makes the brain see strange visions",
      "Humans continue to make new neurons throughout life in response to mental activity.",
      "A living brain is so soft you could cut it with a table knife.",
      "Women are twice more talkative than men! It has been estimated that on average, men speak 12,500 words and women speak about 25,500 words in a day.",
      "Men change their minds two to three times more often than women. Most women take longer to make a decision than men do, but once they make a decision they are more likely to stick to it.",
      "The human brain is not only looking for the unexpected, it actually craves the unexpected.",
      "Married people are less happy than singles, but people with children are the same as childless couples.",
      "Each time we blink, our brain kicks in and keeps things illuminated so the whole world doesn’t go dark each time we blink (about 20,000 times a day).",
      "When asking people about shocking events (like 11-9-2001), they are able to tell in great detail their memory of that day, and the majority of their memory would be correct. ",
      "People with little to do are happier than those that are always busy.",
      "People whose mind wanders a lot are more creative, but worse problem solvers",
      "Only Seven Emotions Are Universal",
      "The Beatty Papyrus, written around 1350 B.C. and discovered at Thebes, is the oldest dream dictionary existing today. It describes special dream-interpreting priests called “Masters of the Secret Things” or “Learned Ones of the Magic Library.”",
      "Individuals  do better than pairs at making decisions",
      "When you are in a happy mood you rely on your logical decision making, AND the outcome is that you make better decisions. When you are in a sad mood you rely on your gut instincts more AND you make better decisions as a result.",
      "9 Percent Of Men And .5% Of Women Are Colour-blind",
      "People are least happy when they are commuting to work.",
      "Adults dream off and on, for a total of about an hour and half to three hours every night.",
      "Nicotine patches and even melatonin (an over-the-counter sleep aid) are reported to decrease the vividness of dreams and nightmares. The nicotine patch in particular is said to decrease the intensity of dreams.",
      "The human brain is the fattest organ in the body and may consists of at least 60% fat.",
      "People who are born blind report no visual imagery in dreams, but they experience a heightened sense of taste, touch, and smell. Those who become sightless between the ages of five and seven may have visual images in their dreams, while those who lose their vision after age seven continue to “see” in their dreams, though images tend to fade as they grow older.",
      "Younger people (1982 onward) want websites to be interesting and fun, while older people (1961 and before) wants websites to be useful (as a tool)",
      "Birth order influences the role of aggression in dreams. While men typically experience more aggressive dreams than women, a firstborn male typically sees himself in a more positive manner than do his younger male siblings. First-born females tend to have more aggressive characters in their dreams.",
      "Women laugh more than twice as much as men.",
      "About 80% of neonatal and newborn sleep time is REM sleep, suggesting a tremendous amount of time dreaming.",
      "Results of several surveys across large population sets indicate that between 18% and 38% of people have experienced at least one precognitive dream and 70% have experienced déjà vu. The percentage of persons that believe precognitive dreaming is possible is even higher, ranging from 63% to 98%",
      "Females dream of males more often than males dream of males. ",
      "There are about 100,000 miles of blood vessels in the brain.",
      "Most laughing occurs by the person who is listening, not the person who is speaking. The person who is listening laughs twice as much.",
      "Children who learn two languages before the age of five alters the brain structure and adults have a much denser gray matter.",
      "Alcohol interferes with brain processes by weakening connections between neurons.",
      "Interrupting a trip makes you enjoy the uninterrupted part less",
      "“Old Hag Syndrome,” or sleep paralysis, occurs in as many as 40% of all people. It happens when a sleeper wakes, recognizes his or her surroundings but is unable to move for as long as a minute. ",
      "Unless people have a reason for being active, they choose to do nothing, thereby conserving energy. Doing nothing makes people relaxed and happy.",
      "The memory-recording processes of the brain seems to switch off during sleep. In so-called non-dreamers, this memory shutdown is more complete than it is for the rest.",
      "More People = More Desire To Compete",
      "If people are presented with a short list of similar products they are least likely to buy the first item on the list.",
      "There are individual cells in the visual cortex of your brain that respond only to horizontal lines, other cells that respond only to vertical lines, other cells that respond to edges, and cells that respond only to certain angles",
      "A full 12% of sighted people dream exclusively in black and white. The remaining number dream in full colour. Studies from 1915 through to the 1950s maintained that the majority of dreams were in black and white, but these results began to change in the 1960s. Today, only 4.4% of the dreams of under-25 year-olds are in black and white. Recent research has suggested that those changing results may be linked to the switch from black-and-white film and TV to colour media.",
      "By the age of 60, most people will have lost about 10% their taste buds. ",
      "The truth is that you have a built-in regulator of sorts so that whether negative events happen or positive events happen, you stay at about the same level of happiness most of the time. Some people are generally happier or less happy than others, and this level of happiness stays constant no matter what happens to them.",
      "You Imagine Objects From Above and Tilted (The “Canonical Perspective”)",
      "Video at a web site is especially compelling. Want people to get a flu shot? Then show a video of other people in line at a clinic getting a flu shot. Want kids to eat vegetables? Then show a video of other kids eating vegetables. Mirror neurons at work.",
      "People that chose to create a habit of eating fruit at lunch will take 1 and a half times longer to make it automatic than those building a new habit of exercising.",
      "People can read multiple columns faster than one single wide column, but they prefer one single wide column",
      "All capital (uppercase) letters are slower for people to read, but only because they aren’t used to them. Mixed case text is only faster to read than uppercase letters because of practice.",
      "Laughter denotes social status. The higher up on the hierarchy you are in a group, the more you will laugh.",
      "83% of the people could produce fake smiles that other people thought were real when they looked at photos of the people pretending to smile.",
      "The estimate is that 40,000,000 inputs come into your brain from your senses every SECOND.",
      "People will buy nothing if the number of choices is to big",
      "Most of us dream every 90 minutes, and the longest dreams (30-45 minutes) occur in the morning.",
      "Modern research has shown that a sharp increase in daily calories results in fewer nocturnal ejaculations in men and an overall decrease in the sexual themes of dreams.",
      "The latest theories are that mirror neurons are also the way we empathize with others. We are literally experiencing what others are experiencing through these mirror neurons, and that allows us to deeply, and literally, understand how another person feels.",
      "Childhood dreams are shorter than adult dreams and nearly 40% of them are nightmares, which may act as a coping mechanism."
    ]
  end

  def show
    type = params[:cid].to_i
    factnr = params[:f].to_i

    if params[:p].to_i.modulo(2) == 0
      beltype = :disbelieve
    else
      beltype = :believe
    end

    pos_opinions = [1,0,0]
    neg_opinions = [0,0,1]

    if type == 0 # no opinions
      interacting_users = []
      pos_opinions = [0,0,0]
      neg_opinions = [0,0,0]
    elsif type == 1 # majority opinions
      interacting_users = []

      r = Random.new(factnr)

      most = 340 + r.rand(60)
      middle = 40 + r.rand(30)
      least = 10 + r.rand(20)


      pos_opinions = [most, middle, least]
      neg_opinions = [least, middle, most]
    elsif type == 2
      interacting_users = [["dr ML Noordzij",gravatar_url('mark+prof@factlink.com', size: 20), beltype]]
    elsif type == 3
      interacting_users = [["dr L Panneels",gravatar_url('mark+prof2@factlink.com', size: 20), beltype ]]
    elsif type == 4
      interacting_username = redis["user_"+(params[:unr] || 0).to_i.to_s].get || 'someone'
      interacting_email = ['c.j.kramer@student.utwente.nl','s0168181@student.utwente.nl'][(params[:unr] || 0).to_i]
      interacting_users = [[interacting_username ,gravatar_url(interacting_email), beltype]]
    elsif type == 5
      interacting_users = [["Jef Vanderoost",gravatar_url('mark+belg@factlink.com', size: 20), beltype]]
    else
      interacting_users = []
    end

    if params[:p].to_i.modulo(2) == 0
      opinions = neg_opinions
    else
      opinions = pos_opinions
    end

    @fact = FakeFact.new opinions, interacting_users, facts[factnr]
    render "facts/extended_show"
  end

  def set_name
    if params[:name].match(/\A[a-zA-Z0-9 .]+\Z/)
      redis["user_"+params[:id].to_i.to_s].set params[:name]
      render text: "name #{params[:id]} set to #{params[:name]}"
    else
      render text: "invalid username #{params[:name]}"
    end
  end

end