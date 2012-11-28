# TODO: Move me out of this file
def load_topic_specific_authority
  Authority.calculation = [
    MapReduce::FactAuthority,
    MapReduce::ChannelAuthority,
    MapReduce::TopicAuthority,
    MapReduce::FactCredibility,
    MapReduce::FactRelationCredibility
  ]
end
load_topic_specific_authority
