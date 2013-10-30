module Dom
  class Project < Domino
    selector ".project"

    attribute :name
    attribute :harvest_id, &:to_i
    attribute :expected_weekly_hours, &:to_i

    def update
      node.click_link("Update")
    end
  end

  class ProjectForm < Domino
    selector "#project-form"

    def self.create(attributes = {})
      first.create(attributes)
    end

    def self.update(attributes = {})
      first.update(attributes)
    end

    def create(attributes = {})
      set(attributes)
      save
    end

    def update(attributes = {})
      set(attributes)
      save
    end

    def set(attributes = {})
      attributes.each { |k, v| send("#{k}=", v) }
    end

    def name
      node.find_field("Name").value
    end

    def name=(value)
      node.fill_in("Name", with: value)
    end

    def harvest_id
      node.find_field("Harvest ID").value.to_i
    end

    def harvest_id=(value)
      node.fill_in("Harvest ID", with: value)
    end

    def expected_weekly_hours
      node.find_field("Expected Weekly Hours").value.to_i
    end

    def expected_weekly_hours=(value)
      node.fill_in("Expected Weekly Hours", with: value)
    end

    def save
      node.click_button("Save")
    end
  end
end
