require "spec_helper"

describe "Links test" do

  it "fails for broken external hash (even if the file exists)" do
    brokenHashExternalFilepath = "#{FIXTURES_DIR}/links/brokenHashExternal.html"
    proofer = make_proofer(brokenHashExternalFilepath)
    proofer.failed_tests.last.should match /linking to ..\/images\/missingImageAlt.html#asdfasfdkafl, but asdfasfdkafl does not exist/
  end

  it "fails for broken internal hash" do
    brokenHashInternalFilepath = "#{FIXTURES_DIR}/links/brokenHashInternal.html"
    proofer = make_proofer(brokenHashInternalFilepath)
    proofer.failed_tests.first.should match /linking to internal hash #noHash that does not exist/
  end

  it "fails for broken external links" do
    brokenLinkExternalFilepath = "#{FIXTURES_DIR}/links/brokenLinkExternal.html"
    proofer = make_proofer(brokenLinkExternalFilepath)
    proofer.failed_tests.first.should match /External link http:\/\/www.asdo3IRJ395295jsingrkrg4.com\/? failed: 0 Couldn't resolve host name/
  end

  it "fails for broken internal links" do
    brokenLinkInternalFilepath = "#{FIXTURES_DIR}/links/brokenLinkInternal.html"
    proofer = make_proofer(brokenLinkInternalFilepath)
    proofer.failed_tests.first.should match /internally linking to .\/notreal.html, which does not exist/
  end

  it "fails for link with no href" do
    missingLinkHrefFilepath = "#{FIXTURES_DIR}/links/missingLinkHref.html"
    proofer = make_proofer(missingLinkHrefFilepath)
    proofer.failed_tests.first.should match /anchor has no href attribute/
  end

  it "should follow redirects" do
    linkWithRedirectFilepath = "#{FIXTURES_DIR}/links/linkWithRedirect.html"
    proofer = make_proofer(linkWithRedirectFilepath)
    proofer.failed_tests.should == []
  end

  it "fails on redirects if not following" do
    linkWithRedirectFilepath = "#{FIXTURES_DIR}/links/linkWithRedirect.html"
    proofer = make_proofer(linkWithRedirectFilepath, { :followlocation => false })
    proofer.failed_tests.last.should match /External link https:\/\/help.github.com\/changing-author-info\/ failed: 301 No error/
  end

  it "does not fail on redirects we're not following" do
    # this test should emit a 301--see above--but we're intentionally supressing it
    linkWithRedirectFilepath = "#{FIXTURES_DIR}/links/linkWithRedirect.html"
    proofer = make_proofer(linkWithRedirectFilepath, { :only_4xx => true, :followlocation => false })
    proofer.failed_tests.should == []
  end

  it "should understand https" do
    linkWithHttpsFilepath = "#{FIXTURES_DIR}/links/linkWithHttps.html"
    proofer = make_proofer(linkWithHttpsFilepath)
    proofer.failed_tests.should == []
  end

  it "fails for broken hash links with status code numbers" do
    brokenLinkWithNumberFilepath = "#{FIXTURES_DIR}/links/brokenLinkWithNumber.html"
    proofer = make_proofer(brokenLinkWithNumberFilepath)
    proofer.failed_tests.first.should match /linking to internal hash #25-method-not-allowed that does not exist/
  end

  it 'properly resolves implicit /index.html in link paths' do
    linkToFolder = "#{FIXTURES_DIR}/links/linkToFolder.html"
    proofer = make_proofer(linkToFolder)
    proofer.failed_tests.should == []
  end

  it 'properly checks links to root' do
    rootLink = "#{FIXTURES_DIR}/links/rootLink/rootLink.html"
    proofer = make_proofer(rootLink)
    proofer.failed_tests.should == []
  end

  it 'properly checks relative links' do
    relativeLinks = "#{FIXTURES_DIR}/links/relativeLinks.html"
    proofer = make_proofer(relativeLinks)
    proofer.failed_tests.should == []
  end

  it 'properly checks ssl links' do
    checkSSLLinks = "#{FIXTURES_DIR}/links/checkSSLLinks.html"
    proofer = make_proofer(checkSSLLinks)
    proofer.failed_tests.should == []
  end

  it 'ignores links marked as ignore data-proofer-ignore' do
    ignorableLinks = "#{FIXTURES_DIR}/links/ignorableLinks.html"
    proofer = make_proofer(ignorableLinks)
    proofer.failed_tests.should == []
  end

  it 'ignores links via href_ignore' do
    ignorableLinks = "#{FIXTURES_DIR}/links/ignorableLinksViaOptions.html"
    proofer = make_proofer(ignorableLinks, {:href_ignore => [/^http:\/\//, /sdadsad/, "../whaadadt.html"]})
    proofer.failed_tests.should == []
  end

  it 'translates links via href_swap' do
    translatedLink = "#{FIXTURES_DIR}/links/linkTranslatedViaHrefSwap.html"
    proofer = make_proofer(translatedLink, {:href_swap => { /\A\/articles\/([\w-]+)/ => "\\1.html" }})
    proofer.failed_tests.should == []
  end

  it 'finds a mix of broken and unbroken links' do
    multipleProblems = "#{FIXTURES_DIR}/links/multipleProblems.html"
    proofer = make_proofer(multipleProblems)
    proofer.failed_tests.first.should match /linking to internal hash #anadaasdadsadschor that does not exist/
  end

  it 'ignores valid mailto links' do
    ignorableLinks = "#{FIXTURES_DIR}/links/mailto_link.html"
    proofer = make_proofer(ignorableLinks)
    proofer.failed_tests.should == []
  end

  it "fails for blank mailto links" do
    blankMailToLink = "#{FIXTURES_DIR}/links/blank_mailto_link.html"
    proofer = make_proofer(blankMailToLink)
    proofer.failed_tests.first.should match /mailto: is an invalid URL/
  end

  it 'ignores valid tel links' do
    ignorableLinks = "#{FIXTURES_DIR}/links/tel_link.html"
    proofer = make_proofer(ignorableLinks)
    proofer.failed_tests.should == []
  end

  it "fails for blank tel links" do
    blankTelLink = "#{FIXTURES_DIR}/links/blank_tel_link.html"
    proofer = make_proofer(blankTelLink)
    proofer.failed_tests.first.should match /tel: is an invalid URL/
  end

  it 'ignores javascript links' do
    javascriptLink = "#{FIXTURES_DIR}/links/javascript_link.html"
    proofer = make_proofer(javascriptLink)
    proofer.failed_tests.should == []
  end

  it "works for valid links missing the protocol" do
    missingProtocolLink = "#{FIXTURES_DIR}/links/link_missing_protocol_valid.html"
    proofer = make_proofer(missingProtocolLink)
    proofer.failed_tests.should == []
  end

  it "fails for invalid links missing the protocol" do
    missingProtocolLink = "#{FIXTURES_DIR}/links/link_missing_protocol_invalid.html"
    proofer = make_proofer(missingProtocolLink)
    proofer.failed_tests.first.should match /Couldn't resolve host name/
  end

  it "works for valid href within link elements" do
    head_link = "#{FIXTURES_DIR}/links/head_link_href.html"
    proofer = make_proofer(head_link)
    proofer.failed_tests.should == []
  end

  it "fails for empty href within link elements" do
    head_link = "#{FIXTURES_DIR}/links/head_link_href_empty.html"
    proofer = make_proofer(head_link)
    proofer.failed_tests.first.should match /anchor has no href attribute/
  end

  it "fails for absent href within link elements" do
    head_link = "#{FIXTURES_DIR}/links/head_link_href_absent.html"
    proofer = make_proofer(head_link)
    proofer.failed_tests.first.should match /anchor has no href attribute/
  end

  it "fails for internal linking to a directory without trailing slash" do
    options = { :followlocation => false }
    internal = "#{FIXTURES_DIR}/links/link_directory_without_slash.html"
    proofer = make_proofer(internal, options)
    proofer.failed_tests.first.should match /without trailing slash/
  end

  it "works for array of links" do
    proofer = make_proofer(["www.github.com", "foofoofoo.biz"])
    proofer.failed_tests.first.should match /foofoofoo.biz\/? failed: 0 Couldn't resolve host name/
  end

  it "works for broken anchors within pre" do
    anchor_pre = "#{FIXTURES_DIR}/links/anchors_in_pre.html"
    proofer = make_proofer(anchor_pre)
    proofer.failed_tests.should == []
  end

  it "works for broken link within pre" do
    link_pre = "#{FIXTURES_DIR}/links/links_in_pre.html"
    proofer = make_proofer(link_pre)
    proofer.failed_tests.should == []
  end

  it "works for pipes in the URL" do
    escape_pipes = "#{FIXTURES_DIR}/links/escape_pipes.html"
    proofer = make_proofer(escape_pipes)
    proofer.failed_tests.should == []
  end

  it "fails for broken hash with query" do
    broken_hash = "#{FIXTURES_DIR}/links/broken_hash_with_query.html"
    proofer = make_proofer(broken_hash)
    proofer.failed_tests.first.should match /linking to internal hash #example that does not exist/
  end

  it "works for directory index file" do
    options = { :directory_index_file => "index.php" }
    link_pointing_to_directory = "#{FIXTURES_DIR}/links/link_pointing_to_directory.html"
    proofer = make_proofer(link_pointing_to_directory, options)
    proofer.failed_tests.should == []
  end

  it "fails if directory index file doesn't exist" do
    options = { :directory_index_file => "README.md" }
    link_pointing_to_directory = "#{FIXTURES_DIR}/links/link_pointing_to_directory.html"
    proofer = make_proofer(link_pointing_to_directory, options)
    proofer.failed_tests.first.should match "internally linking to folder-php/, which does not exist"
  end

  it "ensures Typhoeus options are passed" do
    options = { ssl_verifypeer: false }
    typhoeus_options_link = "#{FIXTURES_DIR}/links/ensure_typhoeus_options.html"
    proofer = make_proofer(typhoeus_options_link, options)
    proofer.failed_tests.should == []
  end

  it "works if subdirectory ends with .html" do
    with_subdirectory_html = "#{FIXTURES_DIR}/links/_site"
    proofer = make_proofer(with_subdirectory_html)
    proofer.failed_tests.should == []
  end

  it "works for hash referring to itself" do
    hashReferringToSelf = "#{FIXTURES_DIR}/links/hashReferringToSelf.html"
    proofer = make_proofer(hashReferringToSelf)
    proofer.failed_tests.should == []
  end

  it "ignores placeholder with name" do
    placeholder_with_name = "#{FIXTURES_DIR}/links/placeholder_with_name.html"
    proofer = make_proofer(placeholder_with_name)
    proofer.failed_tests.should == []
  end

  it "ignores placeholder with id" do
    placeholder_with_id = "#{FIXTURES_DIR}/links/placeholder_with_id.html"
    proofer = make_proofer(placeholder_with_id)
    proofer.failed_tests.should == []
  end

  it "fails for placeholder with empty id" do
    empty_id = "#{FIXTURES_DIR}/links/placeholder_with_empty_id.html"
    proofer = make_proofer(empty_id)
    proofer.failed_tests.first.should match /anchor has no href attribute/
  end
end
