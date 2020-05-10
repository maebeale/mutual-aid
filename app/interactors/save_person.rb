class SavePerson < BaseInteractor
  integer :id, default: nil

  record  :preferred_contact_method, class: 'ContactMethod'
  hash    :location, strip: false

  string  :name
  string  :email, default: nil
  string  :phone, default: nil

  def execute
    ensure_location_id_provided_if_existing_person!

    merging_errors(in_transaction: true) do
      location_record = compose SaveLocation, location
      person_params = inputs.merge location: location_record

      if id?
        Person.update id, person_params
      else
        Person.create person_params
      end
    end
  end

  private

    def ensure_location_id_provided_if_existing_person!
      fail 'Missing location.id param attempting to update existing person' if id? && location[:id].blank?
    end
end
