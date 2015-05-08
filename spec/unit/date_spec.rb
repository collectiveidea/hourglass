describe Date do
  describe "named weekday methods" do
    it "returns the first occurrence of that weekday in the past" do
      Timecop.travel(Date.new(2015, 5, 6)) # Wednesday

      expect(Date.monday).to    eq(Date.new(2015, 5, 4))
      expect(Date.tuesday).to   eq(Date.new(2015, 5, 5))
      expect(Date.wednesday).to eq(Date.new(2015, 4, 29))
      expect(Date.thursday).to  eq(Date.new(2015, 4, 30))
      expect(Date.friday).to    eq(Date.new(2015, 5, 1))
      expect(Date.saturday).to  eq(Date.new(2015, 5, 2))
      expect(Date.sunday).to    eq(Date.new(2015, 5, 3))
    end
  end
end
