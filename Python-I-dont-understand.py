
# download some stuff
import pathlib
import requests
def download_file(url: str, tar_path: pathlib.Path, **request_kwargs):
    with tar_path.open("wb")as f:
        response = requests.get(url, stream=True, **request_kwargs)
        for chunk in response.iter_content(chunk_size=1024):
            if chunk:  # filter out keep-alive new chunks
                f.write(chunk)
    return tar_path



# andreasl: maybe the following just has something to do with inheritance and self.command not
# directly being accessible via children
# found here:  https://codereview.celeraone.com/#/c/c1-robotframework/+/15414/13/c1/robotframework/daemon/hook_server/generic.py@64
    @property
    def method(self) -> str:
        """Convenience accessor to fetch the current request's HTTP method."""
        return self.command



@property  # decorator


sys.path.append(os.path.join(os.path.dirname(__file__), '..'))



# :rtype:  # maybe .rst doc's equivalent to doxygen's @return statement