class Member < ActiveRecord::Base
  belongs_to :open_tok_session

  def self.cleanup
    # Remove stale members
    stale_members = Member.where(:updated_at.lt => (DateTime.now - 7.minutes)).all
    stale_members.each{|r| r.destroy} unless stale_members.empty?
  end
end