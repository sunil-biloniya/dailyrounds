//
//  BookmarkTableCell.swift
//  Dailyrounds
//
//  Created by sunil biloniya on 21/06/24.
//

import UIKit
import SDWebImage

class BookmarkTableCell: UITableViewCell {
    /// outlets
    @IBOutlet weak var ic_image: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAuthorName: UILabel!
    @IBOutlet weak var lblRatingCount: UILabel!
    @IBOutlet weak var lblAvgRating: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /// set books data
    var details: BookmarkDoc? {
        didSet {
            guard let details = details else { return }
            lblAvgRating.text = details.ratingsAverage?.clean ?? "0"
            lblRatingCount.text = "\(details.ratingsCount ?? 0)"
            lblTitle.text = details.title ?? ""
            lblAuthorName.text = details.authorName?.first ?? ""
            /// set image
            if let url = "https://covers.openlibrary.org/b/id/\(details.coverI ?? 0)-M.jpg".makeURL() {
                self.ic_image.sd_setImage(with: url, placeholderImage: nil)
            }
            
        }
    }
    /// set saved books data
    var savedDetails: BookmarkEntity? {
        didSet {
            guard let savedDetails = savedDetails else { return }
            lblAvgRating.text = savedDetails.ratingsAverage.clean
            lblRatingCount.text = "\(savedDetails.ratingsCount)"
            lblTitle.text = savedDetails.title ?? ""
            lblAuthorName.text = savedDetails.authorName ?? ""
            if let url = "https://covers.openlibrary.org/b/id/\(savedDetails.coverI ?? 0)-M.jpg".makeURL() {
                self.ic_image.sd_setImage(with: url, placeholderImage: nil)
            }
        }
    }
}
