# frozen_string_literal: true

# rubocop:todo Layout/CommentIndentation
SimpleForm.setup do |config| # rubocop:disable Metrics/BlockLength
  # Default class for buttons
  config.button_class = 'button'

  # Define the default class of the input wrapper of the boolean input.
  # config.boolean_label_class = 'checkbox'
  config.boolean_label_class = 'form-check-label'

  # How the label text should be generated altogether with the required text.
  config.label_text = lambda { |label, required, explicit_label| "#{label} #{required}" }

  # Define the way to render check boxes / radio buttons with labels.
  config.boolean_style = :inline

  # You can wrap each item in a collection of radio/check boxes with a tag
  config.item_wrapper_tag = :div

  # Defines if the default input wrapper class should be included in radio
  # collection wrappers.
  config.include_default_input_wrapper_class = false

  # CSS class to add for error notification helper.
  config.error_notification_class = 'notification is-danger'

  # Method used to tidy up errors. Specify any Rails Array method.
  # :first lists the first message for each field.
  # :to_sentence to list all errors for each field.
  config.error_method = :to_sentence

  # add validation classes to `input_field`
  config.input_field_error_class = 'is-invalid'
  config.input_field_valid_class = 'is-valid'

  # config.generate_additional_classes_for = ['field']

  # Wrappers for forms and inputs
  config.default_wrapper = :horizontal_form
  config.wrapper_mappings = {
    boolean:       :horizontal_boolean,
    check_boxes:   :vertical_checkboxes,
    collection:    :vertical_collection,
    date:          :horizontal_multi_select,
    datetime:      :horizontal_multi_select,
    file:          :vertical_file,
    radio_buttons: :horizontal_radio,
    range:         :vertical_range,
    time:          :horizontal_multi_select
  }

  # vertical forms
  #
  # bulma vertical default_wrapper
  config.wrappers :vertical_form, tag: 'div', class: 'field', error_class: 'has-error' do |b|
    b.use :html5
    # b.use :placeholder
    b.use :placeholder, class: 'help has-text-grey-light'
    b.optional :maxlength
    b.optional :minlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly
    # b.use :label, class: 'label'
    # b.use :input, class: 'input', wrap_with: { tag: 'div', class: 'control' }, error_class: 'is-danger', valid_class: 'is-success'
    # b.use :hint, wrap_with: { tag: 'p', class: 'help has-text-grey-light' }
    # b.use :hint, wrap_with: { tag: 'small', class: 'form-text text-muted' }
    b.wrapper tag: 'div', class: 'field' do |ba|
      ba.use :label, class: 'label', wrap_with: {tag: 'label', class: 'label'}
      ba.use :input, class: 'input'
      ba.use :full_error, wrap_with: {tag: 'div', class: 'help invalid-feedback is-danger'}
      ba.use :hint, wrap_with: {tag: 'p', class: 'help has-text-grey-light'}
    end
  end

  # bulma vertical select_form
  config.wrappers :select_form, tag: 'div', class: 'control' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :pattern
    b.optional :readonly
    b.use :input, wrap_with: {tag: 'div', class: 'select'}
    b.use :full_error, wrap_with: {tag: 'div', class: 'help invalid-feedback is-danger'}
    # b.use :hint, wrap_with: { tag: 'small', class: 'form-text text-muted' }
  end

  ## bulma vertical file input
  config.wrappers :vertical_file, tag: 'div', class: 'file field', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :readonly
    b.use :label, class: 'label'
    b.wrapper tag: 'div', class: 'control' do |ba|
      ba.use :input, class: 'input'
    end
    b.use :input, class: 'file-input', wrap_with: {tag: 'label', class: 'file-label'}
    b.use :full_error, wrap_with: {tag: 'div', class: 'help invalid-feedback is-danger'}
    b.use :hint, wrap_with: {tag: 'small', class: 'form-text text-muted'}
  end

  # bulma extension vertical input for boolean
  config.wrappers :vertical_boolean, tag: 'div', class: 'field', error_class: 'has-error' do |b|
    b.use :html5
    b.optional :readonly
    b.use :input, class: 'is-checkradio is-info'
    b.use :label
    b.wrapper :form_check_wrapper, tag: 'div', class: 'control' do |bb|
      bb.use :input, wrap_with: {tag: 'label', class: 'checkbox'}
      bb.use :label, class: 'checkbox'
      bb.use :full_error, wrap_with: {tag: 'div', class: 'help invalid-feedback is-danger'}
      bb.use :hint, wrap_with: {tag: 'small', class: 'form-text text-muted'}
    end
    # b.wrapper tag: 'div', class: 'checkbox' do |ba|
    #     ba.use :label_input
    #   end
    #
    #   b.use :error, wrap_with: { tag: 'span', class: 'hint' }
    #   b.use :hint,  wrap_with: { tag: 'p', class: 'hint' }
    # end
  end

  ## vertical range input
  config.wrappers :vertical_range, tag: 'div', class: 'form-group', error_class: 'form-group-invalid', valid_class: 'form-group-valid' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :readonly
    b.optional :step
    b.use :label
    b.use :input, class: 'form-control-range', error_class: 'is-invalid', valid_class: 'is-valid'
    b.use :full_error, wrap_with: {tag: 'div', class: 'help invalid-feedback is-danger'}
    b.use :hint, wrap_with: {tag: 'small', class: 'form-text text-muted'}
  end

  config.wrappers :vertical_radio, tag: 'div', class: 'vertical-radio', error_class: 'has-error' do |b|
    b.use :html5
    b.optional :readonly
    b.wrapper tag: 'div', class: 'field' do |ba|
      ba.use :label, class: 'label field-label field-label-left'
      ba.wrapper tag: 'div', class: 'field-body' do |baa|
        baa.wrapper tag: 'div', class: 'control' do |baaa|
          baaa.use :input, class: 'radio', type: 'radio'
        end
      end
    end
    b.use :full_error, wrap_with: {tag: 'span', class: 'help invalid-feedback is-danger'}
    b.use :hint, wrap_with: {tag: 'p', class: 'help has-text-grey-light'}
  end

  config.wrappers :vertical_checkboxes, tag: 'div', class: 'vertical-checkboxes', error_class: 'has-error' do |b|
    b.use :html5
    b.optional :readonly
    b.wrapper tag: 'div', class: 'field' do |ba|
      ba.use :label, class: 'label field-label-left'
      ba.wrapper tag: 'div', class: 'field-body' do |baa|
        baa.wrapper tag: 'div', class: 'control' do |baaa|
          baaa.use :input, class: 'checkbox', type: 'checkbox'
        end
      end
    end
    b.use :full_error, wrap_with: {tag: 'span', class: 'help invalid-feedback is-danger'}
    b.use :hint, wrap_with: {tag: 'p', class: 'help has-text-grey-light'}
  end

    ## vertical input for radio buttons and check boxes
    # config.wrappers :vertical_collection, item_wrapper_class: 'form-check', tag: 'fieldset', class: 'form-group', error_class: 'form-group-invalid', valid_class: 'form-group-valid' do |b|
    # b.use :html5
    # b.optional :readonly
    # b.wrapper :legend_tag, tag: 'legend', class: 'col-form-label pt-0' do |ba|
    # ba.use :label_text
    # end
    # b.use :input, class: 'form-check-input', error_class: 'is-invalid', valid_class: 'is-valid'
    # b.use :full_error, wrap_with: { tag: 'div', class: 'help invalid-feedback is-danger' }
    # b.use :hint, wrap_with: { tag: 'small', class: 'form-text text-muted' }
    # end

    ## vertical input for inline radio buttons and check boxes
    # config.wrappers :vertical_collection_inline, item_wrapper_class: 'form-check form-check-inline', tag: 'fieldset', class: 'form-group', error_class: 'form-group-invalid', valid_class: 'form-group-valid' do |b|
    # b.use :html5
    # b.optional :readonly
    # b.wrapper :legend_tag, tag: 'legend', class: 'col-form-label pt-0' do |ba|
    # ba.use :label_text
    # end
    # b.use :input, class: 'form-check-input', error_class: 'is-invalid', valid_class: 'is-valid'
    # b.use :full_error, wrap_with: { tag: 'div', class: 'help invalid-feedback is-danger' }
    # b.use :hint, wrap_with: { tag: 'small', class: 'form-text text-muted' }
    # end

    # config.wrappers :label_only,
    #                 class: "label",
    #                 hint_class: "field-with-hint" do |b|
    #   b.use :label
    #   b.use :hint,  wrap_with: { tag: :span, class: "help has-text-grey-light" }
    # end

  config.wrappers :inline_input, tag: 'div', class: 'field is-horizontal' do |b|
    b.wrapper :label, tag: 'div', class: 'field-label-left is-normal' do |bl|
      bl.optional :label, class: 'label'
    end
    b.wrapper :input, tag: 'div', class: 'field-body' do |bi|
      bi.wrapper :input, tag: 'div', class: 'field' do |bf|
        bf.use :input, class: 'input'
        bf.use :full_error, wrap_with: {tag: 'span', class: 'help invalid-feedback is-danger'}
        bf.optional :hint, wrap_with: {tag: 'p', class: 'help'}
      end
    end
  end
    #
    # config.wrappers :boolean, tag: 'div', class: 'control', error_class: 'has-error' do |b|
    #   b.use :html5
    #   b.optional :readonly
    #   b.wrapper :label, tag: "label", class: "checkbox" do |ba|
    #     ba.use :input, class: 'checkbox'
    #     ba.use :label_text
    #     ba.use :hint, wrap_with: {tag: 'p', class: 'help'}
    #   end
    # end

    ## horizontal forms
    #
    ## horizontal default_wrapper
  config.wrappers :horizontal_form, tag: 'div', class: '', error_class: 'has-error', valid_class: 'has-no-error' do |b|
    b.use :html5
    b.use :placeholder, class: 'help has-text-grey-light'
    b.optional :maxlength
    b.optional :minlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly
    b.wrapper :grid_wrapper, tag: 'div', class: 'field' do |ba|
      ba.use :label, class: 'label', wrap_with: {tag: 'label', class: 'label'}
      ba.use :input, class: 'input', error_class: 'is-invalid', valid_class: 'is-valid'
      ba.use :full_error, wrap_with: {tag: 'div', class: 'help invalid-feedback is-danger'}
      ba.use :hint, wrap_with: {tag: 'p', class: 'help has-text-grey-light'}
    end
  end

    ## horizontal input for boolean
    # config.wrappers :horizontal_boolean, tag: 'div', class: 'form-group row', error_class: 'form-group-invalid', valid_class: 'form-group-valid' do |b|
    # b.use :html5
    # b.optional :readonly
    # b.wrapper tag: 'label', class: 'col-sm-3' do |ba|
    # ba.use :label_text
    # end
    # b.wrapper :grid_wrapper, tag: 'div', class: 'col-sm-9' do |wr|
    # wr.wrapper :form_check_wrapper, tag: 'div', class: 'form-check' do |bb|
    # bb.use :input, class: 'form-check-input', error_class: 'is-invalid', valid_class: 'is-valid'
    # bb.use :label, class: 'form-check-label'
    # bb.use :full_error, wrap_with: { tag: 'div', class: 'help invalid-feedback is-danger' }
    # bb.use :hint, wrap_with: { tag: 'small', class: 'form-text text-muted' }
    # end
    # end
    # end

    # bulma extension vertical input for boolean
  config.wrappers :horizontal_boolean, tag: 'div', class: 'field horizontal-boolean is-horizontal', error_class: 'has-error' do |b|
    b.use :html5
    b.optional :readonly
    b.use :input, class: 'is-checkradio is-info'
    b.use :label
    b.wrapper tag: 'div', class: 'field-body' do |ba|
      ba.wrapper :form_check_wrapper, tag: 'div', class: 'control field is-horizontal' do |bb|
        bb.use :input, wrap_with: {tag: 'label field-label field-label-left', class: 'checkbox'}
        bb.use :label, class: 'checkbox'
        bb.use :full_error, wrap_with: {tag: 'div', class: 'help invalid-feedback is-danger'}
        bb.use :hint, wrap_with: {tag: 'small', class: 'form-text text-muted'}
      end
    end
    # b.wrapper tag: 'div', class: 'checkbox' do |ba|
      #     ba.use :label_input
      #   end
      #
      #   b.use :error, wrap_with: { tag: 'span', class: 'hint' }
      #   b.use :hint,  wrap_with: { tag: 'p', class: 'hint' }
    # end
  end

  config.wrappers :horizontal_radio, tag: 'div', class: 'horizontal-radio is-horizontal', error_class: 'has-error' do |b|
    b.use :html5
    b.optional :readonly
    b.wrapper tag: 'div', class: 'field' do |ba|
      ba.use :label, class: 'label field-label'
      ba.wrapper tag: 'div', class: 'field-body' do |baa|
        baa.wrapper tag: 'div', class: 'control field is-horizontal' do |baaa|
          baaa.use :input, class: 'radio', type: 'radio'
        end
      end
      ba.use :full_error, wrap_with: {tag: 'span', class: 'help invalid-feedback is-danger'}
      ba.use :hint, wrap_with: {tag: 'p', class: 'help has-text-grey-light'}
    end
  end

  config.wrappers :horizontal_checkboxes, tag: 'div', class: 'horizontal-checkboxes is-horizontal', error_class: 'has-error' do |b|
    b.use :html5
    b.optional :readonly
    b.wrapper tag: 'div', class: 'field' do |ba|
      ba.use :label, class: 'label field-label'
      ba.wrapper tag: 'div', class: 'field-body' do |baa|
        baa.wrapper tag: 'div', class: 'control field is-horizontal' do |baaa|
          baaa.use :input, class: 'checkbox', type: 'checkbox'
        end
      end
    end
    b.use :full_error, wrap_with: {tag: 'span', class: 'help invalid-feedback is-danger'}
    b.use :hint, wrap_with: {tag: 'p', class: 'help has-text-grey-light'}
  end

    ## horizontal input for radio buttons and check boxes
    # config.wrappers :horizontal_collection, item_wrapper_class: 'form-check', tag: 'div', class: 'form-group row', error_class: 'form-group-invalid', valid_class: 'form-group-valid' do |b|
    # b.use :html5
    # b.optional :readonly
    # b.use :label, class: 'col-sm-3 form-control-label'
    # b.wrapper :grid_wrapper, tag: 'div', class: 'col-sm-9' do |ba|
    # ba.use :input, class: 'form-check-input', error_class: 'is-invalid', valid_class: 'is-valid'
    # ba.use :full_error, wrap_with: { tag: 'div', class: 'help invalid-feedback is-danger' }
    # ba.use :hint, wrap_with: { tag: 'small', class: 'form-text text-muted' }
    # end
    # end

    ## horizontal input for inline radio buttons and check boxes
    # config.wrappers :horizontal_collection_inline, item_wrapper_class: 'form-check form-check-inline', tag: 'div', class: 'form-group row', error_class: 'form-group-invalid', valid_class: 'form-group-valid' do |b|
    # b.use :html5
    # b.optional :readonly
    # b.use :label, class: 'col-sm-3 form-control-label'
    # b.wrapper :grid_wrapper, tag: 'div', class: 'col-sm-9' do |ba|
    # ba.use :input, class: 'form-check-input', error_class: 'is-invalid', valid_class: 'is-valid'
    # ba.use :full_error, wrap_with: { tag: 'div', class: 'help invalid-feedback is-danger' }
    # ba.use :hint, wrap_with: { tag: 'small', class: 'form-text text-muted' }
    # end
    # end

    ## horizontal file input
    # config.wrappers :horizontal_file, tag: 'div', class: 'form-group row', error_class: 'form-group-invalid', valid_class: 'form-group-valid' do |b|
    # b.use :html5
    # b.use :placeholder
    # b.optional :maxlength
    # b.optional :minlength
    # b.optional :readonly
    # b.use :label, class: 'col-sm-3 form-control-label'
    # b.wrapper :grid_wrapper, tag: 'div', class: 'col-sm-9' do |ba|
    # ba.use :input, error_class: 'is-invalid', valid_class: 'is-valid'
    # ba.use :full_error, wrap_with: { tag: 'div', class: 'help invalid-feedback is-danger' }
    # ba.use :hint, wrap_with: { tag: 'small', class: 'form-text text-muted' }
    # end
    # end

  ## bulma vertical multi select
  config.wrappers :vertical_multi_select, tag: 'div', class: 'field', error_class: 'has-error' do |b|
    b.use :html5
    b.optional :readonly
    b.use :label, class: 'label'
    b.wrapper tag: 'div', class: 'control' do |ba|
      ba.use :input, class: 'input', error_class: 'is-danger', valid_class: 'is-success'
    end
    # b.wrapper tag: 'div', class: 'control field is-inline-flex' do |ba|
    #     ba.use :input, class: 'input'
    #     ba.use :placeholder, class: 'help has-text-grey-light'
    #     ba.use :error, wrap_with: { tag: 'span', class: 'help has-text-grey-light' }
    #     ba.use :hint,  wrap_with: { tag: 'p', class: 'help has-text-grey-light' }
    # end
    b.use :full_error, wrap_with: {tag: 'div', class: 'help invalid-feedback is-danger'}
    b.use :hint, wrap_with: {tag: 'small', class: 'help'}
  end

    ## horizontal multi select
  config.wrappers :horizontal_multi_select, tag: 'div', class: 'field', error_class: 'has-error' do |b|
    b.use :html5
    b.optional :readonly
    b.use :label, class: 'label'
    b.wrapper :grid_wrapper, tag: 'div', class: 'control' do |ba|
      ba.wrapper tag: 'div', class: 'field is-inline-flex' do |bb|
        bb.use :input, class: 'input', error_class: 'is-invalid', valid_class: 'is-valid'
        ba.use :hint, wrap_with: {tag: 'small', class: 'help'} # adds hint above select
      end
      ba.use :full_error, wrap_with: {tag: 'div', class: 'help is-invalid invalid-feedback is-danger'}
    end
  end

    ## horizontal range input
    # config.wrappers :horizontal_range, tag: 'div', class: 'form-group row', error_class: 'form-group-invalid', valid_class: 'form-group-valid' do |b|
    # b.use :html5
    # b.use :placeholder
    # b.optional :readonly
    # b.optional :step
    # b.use :label, class: 'col-sm-3 form-control-label'
    # b.wrapper :grid_wrapper, tag: 'div', class: 'col-sm-9' do |ba|
    # ba.use :input, class: 'form-control-range', error_class: 'is-invalid', valid_class: 'is-valid'
    # ba.use :full_error, wrap_with: { tag: 'div', class: 'help invalid-feedback is-danger' }
    # ba.use :hint, wrap_with: { tag: 'small', class: 'form-text text-muted' }
    # end
    # end

    ## inline forms
    ##
    ## inline default_wrapper
    # config.wrappers :inline_form, tag: 'span', error_class: 'form-group-invalid', valid_class: 'form-group-valid' do |b|
    # b.use :html5
    # b.use :placeholder
    # b.optional :maxlength
    # b.optional :minlength
    # b.optional :pattern
    # b.optional :min_max
    # b.optional :readonly
    # b.use :label, class: 'sr-only'

    # b.use :input, class: 'form-control', error_class: 'is-invalid', valid_class: 'is-valid'
    # b.use :error, wrap_with: { tag: 'div', class: 'invalid-feedback' }
    # b.optional :hint, wrap_with: { tag: 'small', class: 'form-text text-muted' }
    # end

    ## inline input for boolean
    # config.wrappers :inline_boolean, tag: 'span', class: 'form-check flex-wrap justify-content-start mr-sm-2', error_class: 'form-group-invalid', valid_class: 'form-group-valid' do |b|
    # b.use :html5
    # b.optional :readonly
    # b.use :input, class: 'form-check-input', error_class: 'is-invalid', valid_class: 'is-valid'
    # b.use :label, class: 'form-check-label'
    # b.use :error, wrap_with: { tag: 'div', class: 'invalid-feedback' }
    # b.optional :hint, wrap_with: { tag: 'small', class: 'form-text text-muted' }
    # end

    ## custom input for boolean
    # config.wrappers :custom_boolean_switch, tag: 'fieldset', class: 'form-group', error_class: 'form-group-invalid', valid_class: 'form-group-valid' do |b|
    # b.use :html5
    # b.optional :readonly
    # b.wrapper :form_check_wrapper, tag: 'div', class: 'custom-control custom-checkbox-switch' do |bb|
    # bb.use :input, class: 'custom-control-input', error_class: 'is-invalid', valid_class: 'is-valid'
    # bb.use :label, class: 'custom-control-label'
    # bb.use :full_error, wrap_with: { tag: 'div', class: 'invalid-feedback' }
    # bb.use :hint, wrap_with: { tag: 'small', class: 'form-text text-muted' }
    # end
    # end

    ## custom input for radio buttons and check boxes
    # config.wrappers :custom_collection, item_wrapper_class: 'custom-control', tag: 'fieldset', class: 'form-group', error_class: 'form-group-invalid', valid_class: 'form-group-valid' do |b|
    # b.use :html5
    # b.optional :readonly
    # b.wrapper :legend_tag, tag: 'legend', class: 'col-form-label pt-0' do |ba|
    # ba.use :label_text
    # end
    # b.use :input, class: 'custom-control-input', error_class: 'is-invalid', valid_class: 'is-valid'
    # b.use :full_error, wrap_with: { tag: 'div', class: 'help invalid-feedback is-danger' }
    # b.use :hint, wrap_with: { tag: 'small', class: 'form-text text-muted' }
    # end

    ## custom input for inline radio buttons and check boxes
    # config.wrappers :custom_collection_inline, item_wrapper_class: 'custom-control custom-control-inline', tag: 'fieldset', class: 'form-group', error_class: 'form-group-invalid', valid_class: 'form-group-valid' do |b|
    # b.use :html5
    # b.optional :readonly
    # b.wrapper :legend_tag, tag: 'legend', class: 'col-form-label pt-0' do |ba|
    # ba.use :label_text
    # end
    # b.use :input, class: 'custom-control-input', error_class: 'is-invalid', valid_class: 'is-valid'
    # b.use :full_error, wrap_with: { tag: 'div', class: 'help invalid-feedback is-danger' }
    # b.use :hint, wrap_with: { tag: 'small', class: 'form-text text-muted' }
    # end

    ## custom file input
    # config.wrappers :custom_file, tag: 'div', class: 'form-group', error_class: 'form-group-invalid', valid_class: 'form-group-valid' do |b|
    # b.use :html5
    # b.use :placeholder
    # b.optional :maxlength
    # b.optional :minlength
    # b.optional :readonly
    # b.use :label, class: 'form-control-label'
    # b.wrapper :custom_file_wrapper, tag: 'div', class: 'custom-file' do |ba|
    # ba.use :input, class: 'custom-file-input', error_class: 'is-invalid', valid_class: 'is-valid'
    # ba.use :label, class: 'custom-file-label'
    # ba.use :full_error, wrap_with: { tag: 'div', class: 'invalid-feedback' }
    # end
    # b.use :hint, wrap_with: { tag: 'small', class: 'form-text text-muted' }
    # end

    ## custom multi select
    # config.wrappers :custom_multi_select, tag: 'div', class: 'form-group', error_class: 'form-group-invalid', valid_class: 'form-group-valid' do |b|
    # b.use :html5
    # b.optional :readonly
    # b.use :label, class: 'form-control-label'
    # b.wrapper tag: 'div', class: 'd-flex flex-row justify-content-between align-items-center' do |ba|
    # ba.use :input, class: 'custom-select mx-1', error_class: 'is-invalid', valid_class: 'is-valid'
    # end
    # b.use :full_error, wrap_with: { tag: 'div', class: 'help invalid-feedback is-danger' }
    # b.use :hint, wrap_with: { tag: 'small', class: 'form-text text-muted' }
    # end

    ## custom range input
    # config.wrappers :custom_range, tag: 'div', class: 'form-group', error_class: 'form-group-invalid', valid_class: 'form-group-valid' do |b|
    # b.use :html5
    # b.use :placeholder
    # b.optional :readonly
    # b.optional :step
    # b.use :label, class: 'form-control-label'
    # b.use :input, class: 'custom-range', error_class: 'is-invalid', valid_class: 'is-valid'
    # b.use :full_error, wrap_with: { tag: 'div', class: 'help invalid-feedback is-danger' }
    # b.use :hint, wrap_with: { tag: 'small', class: 'form-text text-muted' }
    # end

    # Input Group - custom component
    # see example app and config at https://github.com/rafaelfranca/simple_form-bootstrap
    # config.wrappers :input_group, tag: 'div', class: 'form-group', error_class: 'form-group-invalid', valid_class: 'form-group-valid' do |b|
    #   b.use :html5
    #   b.use :placeholder
    #   b.optional :maxlength
    #   b.optional :minlength
    #   b.optional :pattern
    #   b.optional :min_max
    #   b.optional :readonly
    #   b.use :label, class: 'form-control-label'
    #   b.wrapper :input_group_tag, tag: 'div', class: 'input-group' do |ba|
    #     ba.optional :prepend
    #     ba.use :input, class: 'form-control', error_class: 'is-invalid', valid_class: 'is-valid'
    #     ba.optional :append
    #   end
    #   b.use :full_error, wrap_with: { tag: 'div', class: 'help invalid-feedback is-danger' }
    #   b.use :hint, wrap_with: { tag: 'small', class: 'form-text text-muted' }
    # end

    ## Floating Labels form
    ##
    ## floating labels default_wrapper
    # config.wrappers :floating_labels_form, tag: 'div', class: 'form-label-group', error_class: 'form-group-invalid', valid_class: 'form-group-valid' do |b|
    # b.use :html5
    # b.use :placeholder
    # b.optional :maxlength
    # b.optional :minlength
    # b.optional :pattern
    # b.optional :min_max
    # b.optional :readonly
    # b.use :input, class: 'form-control', error_class: 'is-invalid', valid_class: 'is-valid'
    # b.use :label, class: 'form-control-label'
    # b.use :full_error, wrap_with: { tag: 'div', class: 'invalid-feedback' }
    # b.use :hint, wrap_with: { tag: 'small', class: 'form-text text-muted' }
    # end

    ## custom multi select
    # config.wrappers :floating_labels_select, tag: 'div', class: 'form-label-group', error_class: 'form-group-invalid', valid_class: 'form-group-valid' do |b|
    # b.use :html5
    # b.optional :readonly
    # b.use :input, class: 'custom-select custom-select-lg', error_class: 'is-invalid', valid_class: 'is-valid'
    # b.use :label, class: 'form-control-label'
    # b.use :full_error, wrap_with: { tag: 'div', class: 'invalid-feedback' }
    # b.use :hint, wrap_with: { tag: 'small', class: 'form-text text-muted' }
    # end

# rubocop:enable Layout/CommentIndentation
end

class StringInput < SimpleForm::Inputs::StringInput
  def input(wrapper_options)
    template.content_tag(:div, super, class: 'control')
  end
end

class TextInput < SimpleForm::Inputs::TextInput
  def input_html_classes
    super.push('textarea')
  end
end

class ArrayInput < SimpleForm::Inputs::StringInput
  def input(wrapper_options) # rubocop:todo Metrics/AbcSize
    input_html_options[:type] ||= input_type

    present = Array(object.public_send(attribute_name)).each_with_index.map { |array_el, idx|
      @builder.text_field(nil, input_html_options.merge(value: array_el,
                                                        id: "input_#{object_name}_#{attribute_name}_#{idx}",
                                                        name: "#{object_name}[#{attribute_name}][]"))
    }.join.html_safe

    empty = @builder.text_field(nil, input_html_options.merge(value: nil,
                                                              id: "input_#{object_name}_#{attribute_name}_",
                                                              name: "#{object_name}[#{attribute_name}][]"))

    present + empty
  end

  def input_type
    :text
  end
end

class DatePickerInput < SimpleForm::Inputs::StringInput
  def input # rubocop:todo Metrics/AbcSize, Metrics/MethodLength
    value = @builder.object.send(attribute_name)
    input_html_options[:value] =
      case value
      when Date, Time, DateTime
        format = options[:format] || :medium
        value.to_s(format)
      else
        value.to_s
      end

    input_html_options[:class] ||= []
    input_html_options[:class] << 'date_picker_input'
    @builder.text_field(attribute_name, input_html_options)
  end
end
