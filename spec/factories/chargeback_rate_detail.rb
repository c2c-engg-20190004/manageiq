FactoryGirl.define do
  factory :chargeback_rate_detail do
    group   "unknown"
    chargeback_rate
    detail_currency { FactoryGirl.create(:chargeback_rate_detail_currency) }

    transient do
      tiers_params nil
    end

    trait :tiers do
      after(:create) do |chargeback_rate_detail, evaluator|
        if evaluator.tiers_params
          evaluator.tiers_params.each do |tier|
            chargeback_rate_detail.chargeback_tiers << FactoryGirl.create(*[:chargeback_tier, tier])
          end
        else
          chargeback_rate_detail.chargeback_tiers << FactoryGirl.create(:chargeback_tier)
        end
      end
    end

    trait :tiers_with_three_intervals do
      chargeback_tiers do
        [
          FactoryGirl.create(:chargeback_tier_first_of_three),
          FactoryGirl.create(:chargeback_tier_second_of_three),
          FactoryGirl.create(:chargeback_tier_third_of_three)
        ]
      end
    end
  end

  trait :fixed do
    group "fixed"
  end

  trait :cpu do
    group "cpu"
  end

  trait :storage_group do
    group "storage"
  end

  trait :memory do
    group "memory"
  end

  trait :megabytes do
    per_unit "megabytes"
  end

  trait :kbps do
    per_unit "kbps"
  end

  trait :gigabytes do
    per_unit "gigabytes"
  end

  trait :daily do
    per_time "daily"
  end

  trait :hourly do
    per_time "hourly"
  end

  factory :chargeback_rate_detail_cpu_used, :traits => [:cpu], :parent => :chargeback_rate_detail do
    description "Used CPU in MHz"
    per_unit    "megahertz"
    chargeable_field { FactoryGirl.build(:chargeable_field_cpu_used) }
  end

  factory :chargeback_rate_detail_cpu_cores_used, :parent => :chargeback_rate_detail do
    description "Used CPU in Cores"
    group       "cpu_cores"
    per_unit    "cores"
    chargeable_field { FactoryGirl.build(:chargeable_field_cpu_cores_used) }
  end

  factory :chargeback_rate_detail_cpu_allocated, :traits => [:cpu, :daily],
                                                 :parent => :chargeback_rate_detail do
    description "Allocated CPU Count"
    per_unit    "cpu"
    chargeable_field { FactoryGirl.build(:chargeable_field_cpu_allocated) }
  end

  factory :chargeback_rate_detail_memory_allocated, :traits => [:memory, :megabytes, :daily],
                                                    :parent => :chargeback_rate_detail do
    description "Allocated Memory in MB"
    chargeable_field { FactoryGirl.build(:chargeable_field_memory_allocated) }
  end

  factory :chargeback_rate_detail_memory_used, :traits => [:memory, :megabytes, :hourly],
                                               :parent => :chargeback_rate_detail do
    description "Used Memory in MB"
    chargeable_field { FactoryGirl.build(:chargeable_field_memory_used) }
  end

  factory :chargeback_rate_detail_disk_io_used, :traits => [:kbps], :parent => :chargeback_rate_detail do
    description "Used Disk I/O in KBps"
    group       "disk_io"
    chargeable_field { FactoryGirl.build(:chargeable_field_disk_io_used) }
  end

  factory :chargeback_rate_detail_net_io_used, :traits => [:kbps], :parent => :chargeback_rate_detail do
    description "Used Network I/O in KBps"
    group       "net_io"
    chargeable_field { FactoryGirl.build(:chargeable_field_net_io_used) }
  end

  factory :chargeback_rate_detail_storage_used, :traits => [:storage_group, :gigabytes],
                                                :parent => :chargeback_rate_detail do
    description "Used Disk Storage in Bytes"
    chargeable_field { FactoryGirl.build(:chargeable_field_storage_used) }
  end

  factory :chargeback_rate_detail_storage_allocated, :traits => [:storage_group, :gigabytes],
                                                     :parent => :chargeback_rate_detail do
    description "Allocated Disk Storage in Bytes"
    chargeable_field { FactoryGirl.build(:chargeable_field_storage_allocated) }
  end

  factory :chargeback_rate_detail_fixed_compute_cost, :traits => [:fixed, :daily], :parent => :chargeback_rate_detail do
    sequence(:description) { |n| "Fixed Compute Cost #{n}" }
    chargeable_field { FactoryGirl.build(:chargeable_field_fixed_compute_1) }
  end

  factory :chargeback_rate_detail_fixed_storage_cost, :traits => [:fixed, :daily], :parent => :chargeback_rate_detail do
    sequence(:description) { |n| "Fixed Storage Cost #{n}" }
  end
end
