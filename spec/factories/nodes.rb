FactoryBot.define do
  factory :node, class: "Node" do
    parent { nil }

    factory :node_with_bird do
      after(:create) do |instance|
        create(:bird, node: instance)
      end
    end
  end
end