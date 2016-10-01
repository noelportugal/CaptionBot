Pod::Spec.new do |spec|
  spec.name = "CaptionBot"
  spec.version = "1.0.0"
  spec.summary = "A swift wrapper framework for Microsoft captionbot.ai"
  spec.homepage = "https://github.com/noelportugal/CaptionBot"
  spec.license = { type: 'MIT', file: 'LICENSE' }
  spec.authors = { "Noel Portugal" => 'noelportugal@email.com' }
  spec.social_media_url = "http://twitter.com/noelportugal"

  spec.platform = :ios, "9.3"
  spec.requires_arc = true
  spec.source = { git: "https://github.com/noelportugal/CaptionBot.git", tag: "v#{spec.version}", submodules: true }
  spec.source_files = "CaptionBot/**/*.{h,swift}"
end
