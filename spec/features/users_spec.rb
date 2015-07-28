feature "Users" do
  let!(:jack) { create(:user, name: "Jack", email: "jack@example.com") }
  let!(:jill) { create(:user, name: "Jill", email: "jill@example.com") }

  scenario "A visitor can see a list of all users" do
    visit users_path

    dom_user_rows = DOM::UserRow.all
    expect(dom_user_rows.count).to eq(2)
    expect(dom_user_rows[0].name).to eq("Jack")
    expect(dom_user_rows[0].email).to eq("jack@example.com")
    expect(dom_user_rows[1].name).to eq("Jill")
    expect(dom_user_rows[1].email).to eq("jill@example.com")
  end

  scenario "A visitor can add a new user" do
    visit users_path

    dom_user_list = DOM::UserList.find!
    dom_user_list.add

    dom_user_form = DOM::UserForm.find!
    dom_user_form.set(
      name: "Jane",
      email: "jane@example.com",
      harvest_id: "573747",
      zenefits_name: "Jane Doe",
      time_zone: "Eastern Time (US & Canada)",
      slack_id: "738YDH2IZJ",
      workdays: %w(Monday Tuesday Wednesday Thursday)
    )
    dom_user_form.submit

    expect(current_path).to eq(users_path)

    dom_user_rows = DOM::UserRow.all
    expect(dom_user_rows.count).to eq(3)
    expect(dom_user_rows[0].name).to eq("Jack")
    expect(dom_user_rows[0].email).to eq("jack@example.com")
    expect(dom_user_rows[1].name).to eq("Jane")
    expect(dom_user_rows[1].email).to eq("jane@example.com")
    expect(dom_user_rows[2].name).to eq("Jill")
    expect(dom_user_rows[2].email).to eq("jill@example.com")

    jane = User.order(:created_at).last
    expect(jane.name).to eq("Jane")
    expect(jane.email).to eq("jane@example.com")
    expect(jane.harvest_id).to eq("573747")
    expect(jane.zenefits_name).to eq("Jane Doe")
    expect(jane.time_zone).to eq("Eastern Time (US & Canada)")
    expect(jane.slack_id).to eq("738YDH2IZJ")
    expect(jane.workdays).to eq(%w(1 2 3 4))
  end

  scenario "A visitor can update a user" do
    visit users_path

    dom_user_row = DOM::UserRow.find_by!(name: "Jack")
    dom_user_row.edit

    dom_user_form = DOM::UserForm.find!
    dom_user_form.set(email: "new.jack@example.com")
    dom_user_form.submit

    expect(current_path).to eq(users_path)

    dom_user_rows = DOM::UserRow.all
    expect(dom_user_rows.count).to eq(2)
    expect(dom_user_rows[0].name).to eq("Jack")
    expect(dom_user_rows[0].email).to eq("new.jack@example.com")

    expect(jack.reload.email).to eq("new.jack@example.com")
  end

  scenario "A visitor can archive a user" do
    visit users_path

    dom_user_row = DOM::UserRow.find_by!(name: "Jack")
    dom_user_row.archive

    expect(current_path).to eq(users_path)
    expect(DOM::UserRow.count).to eq(1)
  end
end
