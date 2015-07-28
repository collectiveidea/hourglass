module DOM
  class UserList < Domino
    selector ".user-list"

    def add
      node.click_link("Add User")
    end

    def table
      within(node) { DOM::UserTable.find! }
    end

    def rows
      table.rows
    end
  end

  class UserTable < Domino
    selector ".user-table"

    def rows
      within_node { DOM::UserRow.all }
    end
  end

  class UserRow < Domino
    selector ".user-row"

    attribute :name, ".user-row-name"
    attribute :email, ".user-row-email"

    def edit
      node.click_link("Edit")
    end

    def archive
      node.click_link("Archive")
    end
  end

  class UserForm < Domino
    selector ".user-form"

    def name
      node.find_field("Name").value
    end

    def name=(name)
      node.fill_in("Name", with: name)
    end

    def email
      node.find_field("Email Address").value
    end

    def email=(email)
      node.fill_in("Email Address", with: email)
    end

    def harvest_id
      node.find_field("Harvest ID").value
    end

    def harvest_id=(harvest_id)
      node.fill_in("Harvest ID", with: harvest_id)
    end

    def zenefits_name
      node.find_field("Name on Zenefits").value
    end

    def zenefits_name=(zenefits_name)
      node.fill_in("Name on Zenefits", with: zenefits_name)
    end

    def time_zone
      node.find_field("Time Zone").value
    end

    def time_zone=(time_zone)
      node.select(time_zone, from: "Time Zone")
    end

    def slack_id
      node.find_field("Slack ID").value
    end

    def slack_id=(slack_id)
      node.fill_in("Slack ID", with: slack_id)
    end

    def workdays
      node.find_field("Scheduled Workdays").all("option").select(&:selected?)
        .map(&:text)
    end

    def workdays=(workdays)
      self.workdays.each { |w| node.unselect(w, from: "Scheduled Workdays") }
      workdays.each { |w| node.select(w, from: "Scheduled Workdays") }
    end

    def set(attributes)
      attributes.each do |key, value|
        send("#{key}=", value)
      end
    end

    def submit
      node.find("[type=submit]").click
    end
  end
end
