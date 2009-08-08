class Ownership < ActiveRecord::Base
  belongs_to :rubygem
  belongs_to :user

  before_create :generate_token
  after_update :remove_unapproveds

  def check_for_upload
    upload = open("http://#{rubygem.rubyforge_project}.rubyforge.org/migrate-#{rubygem.name}.html")

    if upload.string == token
      update_attribute(:approved, true)
    end
  end

  protected

    def generate_token
      self.token = "#{rand(1000)}#{Time.now.to_f}".to_md5
    end

    def remove_unapproveds
      self.class.destroy_all(:rubygem_id => rubygem_id, :approved => false) if approved
    end
end
