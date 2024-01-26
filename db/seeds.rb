# Prevent welcome emails while seeding db:
ActiveJob::Base.queue_adapter = :inline
ActionMailer::Base.delivery_method = :test
ActionMailer::Base.perform_deliveries = false

# clear db
User.destroy_all

# create demo users
User.create(fname: 'Humble', lname: 'Bragger', email: 'humblebragger@humblebrag.com', password: 'humblebaby')
User.create(fname: 'Fitness', lname: 'Grampa', email: 'fitnessgrampacer@test.com', password: 'pacertest')

# generate demo user posts
User.all.each do |demo_user|
  rand(2..3).times do
    post = demo_user.posts.build(content: "'#{Faker::Movies::HarryPotter.quote}'")
    post.save
  end
end

# Clears used values for all generators
Faker::UniqueGenerator.clear

# generate names
names = []
until names.length == 24
  name = Faker::Movies::HarryPotter.unique.character.split(' ')
  names << name if name.size == 2
end

# generate users
names.each do |n|
  fake_user = User.create!(fname: n[0],
                           lname: n[1],
                           email: "#{n[0]}_#{n[1]}@wizarding.world",
                           password: 'alohomora')
  # generate posts
  rand(2..3).times do
    post = fake_user.posts.build(content: "'#{Faker::Movies::HarryPotter.quote}'")
    post.save
  end
end

# generate friend requests
User.all.each do |user|
  undecided_friends = user.recieved_friend_requests.collect { |request| request.sent_by_id } << user.id
  possible_friends = User.where.not(id: undecided_friends).sample(8)
  possible_friends.uniq.each do |potential_friend|
    request = user.sent_friend_requests.build(sent_to_id: potential_friend.id)
    request.save

    notice = potential_friend.notifications.build(notice_id: user.id, notice_type: 'friendRequest')
    notice.save
  end
end

# generate friends
User.all.each do |user|
  rand(1..3).times do |n|
    accepted_friend = user.pending_requests_received[n]
    next unless accepted_friend

    friendship = Friendship.find_by(sent_by_id: accepted_friend.id, sent_to_id: user.id, status: false)
    next unless friendship

    friendship.status = true
    friendship.save
    friendship2 = user.sent_friend_requests.build(sent_to_id: accepted_friend.id, status: true)
    friendship2.save
  end
end

# generate likes & comments
User.all.each do |user|
  user.friends.each do |f|
    rand(1..3).times do |n|
      liked_post = f.posts[n]
      next unless liked_post

      liked_post_like = liked_post.likes.build(user_id: user.id)
      liked_post_like.save
      like_post_notification = f.notifications.build(notice_id: user.id,
                                                     post_id: liked_post.id,
                                                     notice_type: 'like-post')
      like_post_notification.save

      if liked_post.comments.size > rand(1..3)
        post_comment = liked_post.comments.sample
        post_comment_like = post_comment.likes.build(user_id: user.id)
        post_comment_like.save

        like_comment_notification = f.notifications.build(notice_id: user.id,
                                                          comment_id: post_comment.id,
                                                          notice_type: 'like-comment')
        like_comment_notification.save

        new_comment = user.comments.build(content: "#{Faker::GreekPhilosophers.quote}",
                                          post_id: liked_post.id,
                                          parent_id: post_comment.id)
      else
        new_comment = user.comments.build(content: "#{Faker::GreekPhilosophers.quote}",
                                          post_id: liked_post.id,
                                          parent_id: nil)
      end
      new_comment.save

      comment_notification = f.notifications.build(post_id: liked_post.id,
                                                   notice_id: user.id,
                                                   notice_type: 'comment')
      comment_notification.save
    end
  end
end
