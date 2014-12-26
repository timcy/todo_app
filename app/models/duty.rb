class Duty < ActiveRecord::Base

  after_create :create_recurring_duties

  def repeat_frequency
    # :never  = 0
    # :daily  = 1
    # :weekly = 7
    # :monthly = next_month || 30
    # :yearly = next_year || 360

    # :weekdays = weekdays || 5 
    # :m_w_f = m_w_f || 3
    # :t_t  = t_t || 2
  end

  def repeat_never?
    self.repeat == 'never' || self.repeat == nil
    # d = Duty.new(name: "Duty 1", start_date: Time.now, end_date: Time.now + 3.hours, send_reminder: true, urgency: "red", repeat: "tomorrow")
  end

  protected

  def create_recurring_duties
    # Save the following values in Duty.repeat column
    # VALUE         For Repeating the duty
    # tomorrow      Daily
    # next_month    Monthly
    # next_year     Yearly
    # m_w_f         Mon, Wed, Fri
    # t_t           Tue, Thu
    # m_to_f        Mon, Tue, Wed, Thu, Fri
    # weekly        weekly

    return if repeat_never?

    # Should come from attr_accessor
    repeat_till = Time.now + 3.days
    
    start = self.start_date.to_date
    # finish = self.repeat_till.to_date
    finish = repeat_till.to_date

    if self.repeat.in?( ["tomorrow", "next_month", "next_year"] )
      while ( start < finish ) do
        puts "*" * 80
        puts "Start - " + start.to_s
        puts "Finish - " + finish.to_s
        puts "*" * 80
        recurring_duty = set_recurring_duty_attributes( start.send("#{self.repeat}") )
        recurring_duty.save
        start = start.send("#{self.repeat}")
      end
    elsif self.repeat.in?( ["m_w_f", "t_t", "m_to_f", "weekly"] )
      sun = 1.day + ((6-self.start_date.wday) % 7).days
      mon = 1.day + ((0-self.start_date.wday) % 7).days
      tue = 1.day + ((1-self.start_date.wday) % 7).days
      wed = 1.day + ((2-self.start_date.wday) % 7).days
      thu = 1.day + ((3-self.start_date.wday) % 7).days
      fri = 1.day + ((4-self.start_date.wday) % 7).days
      sat = 1.day + ((5-self.start_date.wday) % 7).days

      m_w_f   = [ mon, wed, fri ]
      t_t     = [ tue, thu ]
      m_to_f  = [ mon, tue, wed, thu, fri ]
      weekly  = [ 7.days ]      

      "#{self.repeat}".each do |next_duty_day|
        while ( start <= finish ) do
          recurring_duty = set_recurring_duty_attributes( start + next_duty_day )
          recurring_duty.save
          start += 7.days
        end
        start = self.start_date.to_date
      end
    end
  end

  def set_recurring_duty_attributes( start_date  )
    rd = Duty.new( name: self.name, urgency: self.urgency, display_in: self.display_in, send_reminder: self.send_reminder, notes: self.notes, created_by: self.created_by )
    rd.repeat = nil   # To prevent from looping
    rd.start_date = start_date
    rd.start_date = rd.start_date.change(hour: self.start_date.hour, min: self.start_date.min )
    # Set the end_date based on the difference in days between self.start_date and self.end_date
    rd.end_date = rd.start_date + (self.end_date.to_date - self.start_date.to_date).to_i
    rd.end_date = rd.end_date.change(hour: self.end_date.hour, min: self.end_date.min )
    return rd
  end

end
