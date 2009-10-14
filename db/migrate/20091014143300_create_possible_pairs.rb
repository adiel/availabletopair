class CreatePossiblePairs < ActiveRecord::Migration
  def self.up
    execute("CREATE VIEW `possible_pairs` AS select `a1`.`id` AS `availability1`,`a2`.`id` AS `availability2`,`a1`.`developer` AS `dev1`,`a2`.`developer` AS `dev2`,`a2`.`contact` AS `contact`,(case when (`a1`.`start_time` >= `a2`.`start_time`) then `a1`.`start_time` else `a2`.`start_time` end) AS `start_time`,(case when (`a1`.`end_time` <= `a2`.`end_time`) then `a1`.`end_time` else `a2`.`end_time` end) AS `end_time` from (`availabilities` `a1` join `availabilities` `a2` on(((`a1`.`developer` <> `a2`.`developer`) and (((`a1`.`start_time` < `a2`.`end_time`) and (`a2`.`start_time` < `a1`.`end_time`)) or ((`a2`.`start_time` < `a1`.`end_time`) and (`a1`.`start_time` < `a2`.`end_time`))))));")
  end

  def self.down
    execute("DROP VIEW IF EXISTS `possible_pairs`;")
  end
end
